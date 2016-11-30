# frozen_string_literal: true
class Layer
  STATUS   = %w(pending saved failed deleted).freeze
  PROVIDER = %w(cartodb rwjson featureservice csv wms).freeze

  include LayerData

  before_update :assign_slug
  before_save   :merge_apps, if: 'application_changed?'

  before_validation(on: :create) do
    set_uuid
  end

  before_validation(on: [:create, :update]) do
    check_slug
    downcase_provider
  end

  validates :name, presence: true, on: :create
  validates :slug, presence: true, format: { with: /\A[^\s!#$%^&*()（）=+;:'"\[\]\{\}|\\\/<>?,]+\z/,
                                             allow_blank: true,
                                             message: 'invalid. Slug must contain at least one letter and no special character' }
  validates_uniqueness_of :name, :slug

  validates_uniqueness_of :default, scope: [:dataset_id, :application], if: 'default?', message: 'Default layer for dataset must be unique'

  scope :recent,             -> { order('updated_at DESC')       }
  scope :filter_pending,     -> { where(status: 0)               }
  scope :filter_saved,       -> { where(status: 1)               }
  scope :filter_failed,      -> { where(status: 2)               }
  scope :filter_inactives,   -> { where(status: 3)               }
  scope :filter_published,   -> { where(published: true)         }
  scope :filter_unpublished, -> { where(published: false)        }
  scope :filter_actives,     -> { filter_saved.filter_published  }

  scope :filter_app,     ->(app)         { where(application: /.*#{app}.*/i) }
  scope :filter_dataset, ->(dataset_id)  { where(dataset_id: dataset_id)     }

  scope :filter_apps,     ->(apps)        { where({ application: { "$in" => apps        } }) }
  scope :filter_datasets, ->(dataset_ids) { where({ dataset_id:  { "$in" => dataset_ids } }) }

  def app_txt
    application.is_a?(String) ? application.split(',') : application
  end

  def status_txt
    STATUS[status - 0]
  end

  def provider_txt
    provider
  end

  def deleted?
    status_txt == 'deleted'
  end

  class << self
    def set_by_id_or_slug(param)
      layerspec_id = self.or({ slug: param }, { id: param }).pluck(:id).min
      find(layerspec_id) rescue nil
    end

    def fetch_all(options)
      status        = options['status'].downcase if options['status'].present?
      published     = options['published']       if options['published'].present?
      layerspec_app = options['app'].downcase    if options['app'].present?
      dataset       = options['dataset']         if options['dataset'].present?

      layerspecs = all
      layerspecs = layerspecs.filter_dataset(dataset) if dataset.present?

      layerspecs = case status
                   when 'pending'  then layerspecs.filter_pending
                   when 'active'   then layerspecs.filter_actives
                   when 'failed'   then layerspecs.filter_failed
                   when 'disabled' then layerspecs.filter_inactives
                   when 'all'      then layerspecs
                   else
                     published.present? ? layerspecs : layerspecs.filter_actives
                   end

      layerspecs = layerspecs.filter_published   if published.present? && published.include?('true')
      layerspecs = layerspecs.filter_unpublished if published.present? && published.include?('false')

      layerspecs = if layerspec_app.present? && !layerspec_app.include?('all')
                     layerspecs.filter_app(layerspec_app)
                   else
                     layerspecs
                   end
      layerspecs
    end

    def fetch_by_datasets(options)
      ids  = options['ids']                 if options['ids'].present?
      apps = options['app'].map(&:downcase) if options['app'].present?

      layerspecs = recent
      layerspecs = layerspecs.filter_actives
      layerspecs = layerspecs.filter_datasets(ids) if ids.present?

      layerspecs = if apps.present? && !apps.include?('all')
                     layerspecs.filter_apps(apps)
                   else
                     layerspecs
                   end
      layerspecs
    end
  end

  private

    def set_uuid
      self.id = SecureRandom.uuid
    end

    def check_slug
      self.slug = self.name.downcase.parameterize if self.name.present? && self.slug.blank?
    end

    def assign_slug
      self.slug = self.slug.downcase.parameterize
    end

    def merge_apps
      self.application = self.application.each { |a| a.downcase! }.uniq
    end

    def downcase_provider
      if Layer::PROVIDER.include?(self.provider.downcase)
        self.provider = self.provider.downcase.parameterize if self.provider.present?
      else
        self.errors.add(:provider, 'not valid')
      end
    end
end

class Layer
  APP      = %w(gfw wrw).freeze
  STATUS   = %w(pending saved failed deleted).freeze
  PROVIDER = %w(cartodb).freeze

  include LayerData

  before_update :assign_slug

  before_validation(on: :create) do
    set_uuid
  end

  before_validation(on: [:create, :update]) do
    check_slug
    downcase_provider_app
  end

  validates :name, presence: true
  validates :slug, presence: true, format: { with: /\A[^\s!#$%^&*()（）=+;:'"\[\]\{\}|\\\/<>?,]+\z/,
                                             allow_blank: true,
                                             message: 'invalid. Slug must contain at least one letter and no special character' }
  validates_uniqueness_of :name, :slug

  scope :recent,             -> { order('updated_at DESC')      }
  scope :filter_pending,     -> { where(status: 0)              }
  scope :filter_saved,       -> { where(status: 1)              }
  scope :filter_failed,      -> { where(status: 2)              }
  scope :filter_inactives,   -> { where(status: 3)              }
  scope :filter_published,   -> { where(published: true)        }
  scope :filter_unpublished, -> { where(published: false)       }
  scope :filter_apps,        -> (app) { where(application: app) }

  scope :filter_actives, -> { filter_saved.filter_published  }

  def app_txt
    application
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
    def find_by_id_or_slug(param)
      layerspec_id = self.or({ slug: param }, { id: param }).pluck(:id).min
      find(layerspec_id) rescue nil
    end

    def fetch_all(options)
      status        = options['status']       if options['status'].present?
      published     = options['published']    if options['published'].present?
      layerspec_app = options['app'].downcase if options['app'].present?

      layerspecs = recent

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

      layerspecs = case layerspec_app
                   when 'gfw'     then layerspecs.filter_apps('gfw')
                   when 'wrw'     then layerspecs.filter_apps('wrw')
                   when 'all'     then layerspecs
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

    def downcase_provider_app
      if Layer::APP.include?(self.application.downcase) && Layer::PROVIDER.include?(self.provider.downcase)
        self.provider    = self.provider.downcase.parameterize    if self.provider.present?
        self.application = self.application.downcase.parameterize if self.application.present?
      else
        self.application = 'not valid application'
        self.provider    = 'not valid provider'
      end
    end
end

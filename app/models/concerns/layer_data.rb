module LayerData
  extend ActiveSupport::Concern

  included do
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name,        type: :string
    field :provider,    type: :string,   default: 'cartodb'
    field :slug,        type: :string
    field :application, type: :string,   default: 'gfw'
    field :category,    type: :string
    field :subcategory, type: :string
    field :iso,         type: :array,    default: []
    field :analyzable,  type: :boolean,  default: false
    field :info_window, type: :boolean,  default: false
    field :group,       type: :string
    field :global,      type: :boolean,  default: false
    field :children,    type: :array,    default: []
    field :info,        type: :hash,     default: { title: '', subtitle: '', legend_template: '', info_window_template: '', z_index: { type: :integer, default: 0 }, color: '', dataset_id: '', title_color: '' }
    field :display,     type: :hash,     default: { display: false, fit_to_geom: false, max_date: { type: :date, default: '' }, min_date: { type: :date, default: '' } }
    field :max_zoom,    type: :integer,  default: 0
    field :custom_data, type: :hash,     default: {}
    field :published,   type: :boolean,  default: false
    field :status,      type: :integer,  default: 1
  end

  class_methods do
  end
end

module LayerData
  extend ActiveSupport::Concern

  included do
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name,                 type: :string
    field :provider,             type: :integer, default: 0
    field :slug,                 type: :string
    field :dataset_id,           type: :string
    field :app_type,             type: :integer, default: 0
    field :category,             type: :string
    field :subcategory,          type: :string
    field :iso,                  type: :string
    field :title,                type: :string
    field :subtitle,             type: :string
    field :analyzable,           type: :boolean, default: false
    field :legend_template,      type: :string
    field :info_window,          type: :boolean, default: false
    field :info_window_template, type: :string
    field :group,                type: :string
    field :global,               type: :boolean, default: false
    field :children,             type: :string
    field :max_zoom,             type: :integer, default: 0
    field :data,                 type: :hash,    default: {}
    field :z_index,              type: :integer, default: 0
    field :color,                type: :string
    field :published,            type: :boolean, default: false
    field :status,               type: :integer, default: 0

    APP      = %w(DEFAULT GFW WRW).freeze
    STATUS   = %w(pending saved failed deleted).freeze
    PROVIDER = %w(CartoDb).freeze
  end

  class_methods do
  end
end

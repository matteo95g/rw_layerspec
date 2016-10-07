# frozen_string_literal: true
module LayerData
  extend ActiveSupport::Concern

  included do
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Attributes::Dynamic

    field :name,               type: :string
    field :dataset_id,         type: :string
    field :provider,           type: :string,  default: 'cartodb'
    field :slug,               type: :string
    field :application,        type: :string,  default: 'gfw'
    field :published,          type: :boolean, default: false
    field :status,             type: :integer, default: 1
    field :default,            type: :boolean, default: false
    field :description,        type: :string
    field :layer_config,       type: :hash,    default: {}
    field :legend_config,      type: :hash,    default: {}
    field :application_config, type: :hash,    default: {}
    field :iso,                type: :array,   default: []
  end

  class_methods do
  end
end

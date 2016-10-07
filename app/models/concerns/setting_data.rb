# frozen_string_literal: true
module SettingData
  extend ActiveSupport::Concern

  included do
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name,     type: :string
    field :token,    type: :string
    field :url,      type: :string
    field :listener, type: :boolean
  end

  class_methods do
  end
end

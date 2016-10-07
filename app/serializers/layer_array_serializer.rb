# frozen_string_literal: true
class LayerArraySerializer < ApplicationSerializer
  attributes :id, :slug, :application, :name, :status, :published, :dataset_id, :default

  def application
    object.app_txt
  end

  def status
    object.try(:status_txt)
  end
end

# frozen_string_literal: true
class LayerSerializer < ApplicationSerializer
  attributes :id, :slug, :application, :name, :default, :datasetId, :provider, :iso, :description,
             :layerConfig, :legendConfig, :applicationConfig

  def application
    object.try(:app_txt)
  end

  def datasetId
    object.try(:dataset_id)
  end

  def provider
    object.try(:provider_txt)
  end

  def layerConfig
    object.layer_config == '{}' ? nil : object.layer_config
  end

  def legendConfig
    object.legend_config == '{}' ? nil : object.legend_config
  end

  def applicationConfig
    object.application_config == '{}' ? nil : object.application_config
  end
end

class LayerSerializer < ApplicationSerializer
  attributes :id, :slug, :application, :name, :default, :dataset_id, :provider, :iso, :description,
             :layer_config, :legend_config, :application_config

  def application
    object.app_txt
  end

  def provider
    object.provider_txt
  end

  def layer_config
    object.layer_config == '{}' ? nil : object.layer_config
  end

  def legend_config
    object.legend_config == '{}' ? nil : object.legend_config
  end

  def application_config
    object.application_config == '{}' ? nil : object.application_config
  end
end

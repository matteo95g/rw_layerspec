class LayerSerializer < ActiveModel::Serializer
  attributes :id, :slug, :application, :name, :default, :dataset_id, :provider, :iso, :description,
             :layer_config, :legend_config, :application_config, :meta

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

  def meta
    data = {}
    data['status']     = object.try(:status_txt)
    data['published']  = object.try(:published)
    data['updated_at'] = object.try(:updated_at)
    data['created_at'] = object.try(:created_at)
    data
  end
end

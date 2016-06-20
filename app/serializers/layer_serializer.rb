class LayerSerializer < ActiveModel::Serializer
  attributes :id, :slug, :application, :name, :provider, :category, :subcategory, :iso, :analyzable, :group, :global,
             :info_window, :max_zoom, :children, :display, :info, :custom_data, :meta

  def application
    object.app_txt
  end

  def provider
    object.provider_txt
  end

  def custom_data
    object.custom_data == '{}' ? nil : object.custom_data
  end

  def display
    object.display == '{}' ? nil : object.display
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

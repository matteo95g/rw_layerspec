class LayerSerializer < ActiveModel::Serializer
  attributes :id, :slug, :application, :name, :provider, :category, :subcategory, :iso, :analyzable, :group, :global,
             :info_window, :max_zoom, :children, :display, :max_date, :min_date, :fit_to_geom, :info, :custom_data, :meta

  def application
    object.app_txt
  end

  def provider
    object.provider_txt
  end

  def custom_data
    object.data == '{}' ? nil : object.data
  end

  def info
    data = {}
    data['title']                = object.try(:title)
    data['subtitle']             = object.try(:subtitle)
    data['legend_template']      = object.try(:legend_template)
    data['info_window_template'] = object.try(:info_window_template)
    data['z_index']              = object.try(:z_index)
    data['color']                = object.try(:color)
    data['dataset_id']           = object.try(:dataset_id)
    data['title_color']          = object.try(:title_color)
    data
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

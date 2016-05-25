class LayerSerializer < ActiveModel::Serializer
  attributes :id, :slug, :name, :data, :meta

  def data
    object.data == '{}' ? nil : object.data
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

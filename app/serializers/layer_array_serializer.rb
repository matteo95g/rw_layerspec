class LayerArraySerializer < ActiveModel::Serializer
  attributes :id, :slug, :name, :status, :published

  def status
    object.try(:status_txt)
  end
end

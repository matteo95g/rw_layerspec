class LayerArraySerializer < ActiveModel::Serializer
  attributes :id, :slug, :application, :name, :status, :published

  def application
    object.app_txt
  end

  def status
    object.try(:status_txt)
  end
end

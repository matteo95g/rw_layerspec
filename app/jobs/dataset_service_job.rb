class DatasetServiceJob < ApplicationJob
  queue_as :default

  def perform(dataset_id, layer_info)
    LayerspecService.connect_to_dataset_service(dataset_id, layer_info)
  end
end

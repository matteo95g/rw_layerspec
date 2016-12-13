# frozen_string_literal: true
require 'curb'
require 'uri'
require 'oj'

module LayerspecService
  class << self
    def connect_to_dataset_service(dataset_id, layer_info)
      params = { dataset: { layer_info: layer_info } }
      url    = URI.decode("#{Service::SERVICE_URL}/dataset/#{dataset_id}/layer")

      @c = Curl::Easy.http_put(URI.escape(url), Oj.dump(params)) do |curl|
        curl.headers['Accept']         = 'application/json'
        curl.headers['Content-Type']   = 'application/json'
        curl.headers['authentication'] = Service::SERVICE_TOKEN
      end
    end
  end
end

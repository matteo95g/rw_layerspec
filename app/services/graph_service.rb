# frozen_string_literal: true
require 'curb'
require 'uri'
require 'oj'

module GraphService
  class << self
    def register_to_graph_service(dataset_id, layer_id)
      url    = URI.decode("#{Service::SERVICE_URL}/v1/graph/layer/#{dataset_id}/#{layer_id}")
      @c = Curl::Easy.http_post(URI.escape(url), {}) do |curl|
        curl.headers['Accept']         = 'application/json'
        curl.headers['Content-Type']   = 'application/json'
        curl.headers['Authorization'] = "Bearer #{ENV['CT_TOKEN']}"
      end
    end

    def delete_from_graph_service(layer_id)
      url    = URI.decode("#{Service::SERVICE_URL}/v1/graph/layer/#{layer_id}")
      @c = Curl::Easy.http_delete(URI.escape(url)) do |curl|
        curl.headers['Accept']         = 'application/json'
        curl.headers['Content-Type']   = 'application/json'
        curl.headers['Authorization'] = "Bearer #{ENV['CT_TOKEN']}"
      end
    end

    
  end
end

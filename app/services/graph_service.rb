# frozen_string_literal: true
require 'curb'
require 'uri'
require 'oj'

module GraphService
  class << self
    def register_to_graph_service(dataset_id, layer_id)
      puts "Registering layer to graph"
      url    = URI.decode("#{Service::SERVICE_URL}/v1/graph/layer/#{dataset_id}/#{layer_id}")
      puts url
      puts ENV['CT_TOKEN']
      @c = Curl::Easy.http_post(URI.escape(url), {}) do |curl|
        curl.headers['Accept']         = 'application/json'
        curl.headers['Content-Type']   = 'application/json'
        curl.headers['Authorization'] = "Bearer #{ENV['CT_TOKEN']}"
      end

      puts "C:"
      puts @c.body_str
      
    end
  end
end

require 'curb'
require 'uri'
require 'oj'

class LayerspecService
  class << self
    def connect_to_dataset_service(dataset_id, layer_info)
      params = { dataset: { dataset_attributes: { layer_info: layer_info } } }
      url    = URI.decode("#{ServiceSetting.gateway_url}/datasets/#{dataset_id}/layer")

      @c = Curl::Easy.http_put(URI.escape(url), Oj.dump(params)) do |curl|
        curl.headers['Accept']         = 'application/json'
        curl.headers['Content-Type']   = 'application/json'
        curl.headers['authentication'] = ServiceSetting.auth_token if ServiceSetting.auth_token.present?
      end
    end
  end
end

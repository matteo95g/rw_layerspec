# frozen_string_literal: true
if ENV["REDISCLOUD_URL"].present?
  $redis = Redis.new(url: ENV["REDISCLOUD_URL"])
else
  host     = ENV.fetch('REDIS_PORT_6379_TCP_ADDR') { 'localhost' }
  port     = ENV.fetch('REDIS_PORT_6379_TCP_PORT') { 6379 }
  password = ENV.fetch('REDIS_PASSWORD') { '' }
  $redis   = Redis.new(host: host, port: port, password: password)
end

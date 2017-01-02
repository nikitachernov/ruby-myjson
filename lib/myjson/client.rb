require 'net/http'

module Myjson
  ##
  # This class defines HTTP requests to Myjson
  class Client
    BASE_URL = 'https://api.myjson.com/'.freeze

    private

    def call(path, id: nil)
      path = "#{path}/#{id}" if id
      uri = URI.join(BASE_URL, path)

      request = yield(uri)
      request.set_content_type('application/json')

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request(request)
      end

      JSON.parse(response.body)
    end

    def get(path, id: nil)
      call(path, id: id) do |uri|
        Net::HTTP::Get.new(uri)
      end
    end

    def post(path, data)
      call(path) do |uri|
        request = Net::HTTP::Post.new(uri)
        request.body = data.to_json
        request
      end
    end

    def put(path, id, data)
      call(path, id: id) do |uri|
        request = Net::HTTP::Put.new(uri)
        request.body = data.to_json
        request
      end
    end
  end
end

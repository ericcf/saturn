require 'net/http'
require 'uri'

module Saturn

  module Remote

    class Document

      def initialize(url)
        @url = URI.parse url
      end

      def get_body
        request = Net::HTTP::Get.new("#{@url.path}?#{@url.query}")
        response = Net::HTTP.start(@url.host, @url.port) do |http|
          http.request(request)
        end
        response.body
      end
    end
  end
end

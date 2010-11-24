require 'json'

module Transport

  class JSON

    class ResponseParser

      attr_reader :result

      def initialize(http_response)
        @http_response = http_response
      end

      def perform
        parse_response_body
      end

      private

      def parse_response_body
        body = @http_response.body
        @result = body ? ::JSON.parse(body) : nil
      end

    end

  end

end

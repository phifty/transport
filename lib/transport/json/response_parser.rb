require 'json'

module Transport

  # Transport layer for json transfers.
  class JSON

    # Parser for the json response.
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
        @result = @http_response ? ::JSON.parse(@http_response) : nil
      end

    end

  end

end

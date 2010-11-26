require 'json'

module Transport

  # Transport layer for json transfers.
  class JSON

    # Builder for the json transport layer requests.
    class RequestBuilder
      include Common::RequestBuilder

      attr_reader :request

      def perform
        set_headers
        convert_parameters_to_json
        convert_body_to_json
        build_http_request
      end

      private

      def set_headers
        headers = @options[:headers] || { }
        headers.merge! "Accept" => "application/json"
        headers.merge! "Content-Type" => "application/json" if @options[:body]
        @options[:headers] = headers
      end

      def convert_parameters_to_json
        return unless @options[:encode_parameters]
        parameters = @options[:parameters]
        if parameters
          parameters.each do |key, value|
            parameters[key] = value.to_json if value.respond_to?(:to_json)
          end
          @options[:parameters] = parameters
        end
      end

      def convert_body_to_json
        body = @options[:body]
        @options[:body] = body.to_json if body
      end

      def build_http_request
        http_request_builder = HTTP::RequestBuilder.new @http_method, @url, @options
        http_request_builder.perform
        @request = http_request_builder.request
      end

    end

  end

end

require 'json'
require File.join(File.dirname(__FILE__), "http")

module Transport

  # Transport layer for json transfers.
  class JSON
    include Common

    autoload :RequestBuilder, File.join(File.dirname(__FILE__), "json", "request_builder")
    autoload :ResponseParser, File.join(File.dirname(__FILE__), "json", "response_parser")

    def perform
      perform_http_transport
      parse_response
    end

    private

    def perform_http_transport
      http_transport = HTTP.new @uri, @request, @options
      http_transport.perform
      @http_response = http_transport.response
    end

    def parse_response
      response_parser = ResponseParser.new @http_response
      response_parser.perform
      @response = response_parser.result
    end

  end

end

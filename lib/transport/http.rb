require 'net/http'
require File.join(File.dirname(__FILE__), "common")

module Transport

  # Common transport layer for http transfers.
  class HTTP
    include Common

    autoload :RequestBuilder, File.join(File.dirname(__FILE__), "http", "request_builder")
    autoload :Formatter, File.join(File.dirname(__FILE__), "http", "formatter")

    def perform
      if RUBY_VERSION < "1.9"
        perform_request_1_8
      else
        perform_request
      end
      log_transport
      check_status_code
    end

    private

    def perform_request
      use_ssl = @uri.scheme == 'https'
      @http_response = Net::HTTP.start(@uri.host, @uri.port, :use_ssl => use_ssl, :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |connection|
        connection.request @request
      end
      @response = @http_response.body
    end

    def perform_request_1_8
      warn "SSL not supported with this version of Ruby" if @uri.scheme == 'https'
      @http_response = Net::HTTP.start(@uri.host, @uri.port) do |connection|
        connection.request @request
      end
      @response = @http_response.body
    end

    def log_transport
      @formatter ||= Formatter.new @options[:logger]
      @formatter.log_transport @uri, @request, @http_response
    end

    def check_status_code
      expected_status_code = @options[:expected_status_code]
      return unless expected_status_code
      response_code = @http_response.code.to_i
      response_body = @http_response.body
      valid_status_code = [ expected_status_code ].flatten.compact.reduce(false) do |valid, status_code|
        valid || status_code == response_code
      end
      raise UnexpectedStatusCodeError.new(response_code, response_body) unless valid_status_code
    end

  end

end

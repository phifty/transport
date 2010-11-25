require 'yaml'

module Transport

  module Spec

    class Faker

      class NoFakeRequestError < StandardError; end

      def initialize(transport_class, fakes)
        @transport_class, @fakes = transport_class, fakes
      end

      def stub_request
        @transport_class.stub(:request).and_return do |*arguments|
          request *arguments
        end
      end

      private

      def request(http_method, url, options = { })
        parameters, headers, expected_status_code = options.values_at :parameters, :headers, :expected_status_code

        request = find_fake_request http_method, url, parameters, headers

        raise NoFakeRequestError, "no fake request found for [#{http_method} #{url} #{parameters.inspect} #{headers.inspect}]" unless request
        raise self.class.unexpected_status_code_error_class.new(
          request[:response][:code].to_i,
          request[:response][:body]
        ) if expected_status_code && expected_status_code.to_s != request[:response][:code]

        request[:response][:body].dup
      end

      def find_fake_request(http_method, url, parameters, headers)
        @fakes.detect do |hash|
          hash[:http_method].to_s == http_method.to_s &&
            hash[:url].to_s == url.to_s &&
            hash[:parameters] == parameters &&
            hash[:headers] == headers
        end
      end

      def self.fake!(type, filename)
        @@fake ||= { }
        @@fake[type] = YAML.load_file filename
        faker = new transport_class(type), @@fake[type]
        faker.stub_request
      end

      def self.transport_class(type)
        send :"transport_#{type}_class"
      rescue NoMethodError
        raise NotImplementedError, "the transport type #{type} is not supported"
      end

      def self.transport_http_class
        Transport::HTTP
      end

      def self.transport_json_class
        Transport::JSON
      end

      def self.unexpected_status_code_error_class
        Transport::UnexpectedStatusCodeError
      end

    end

  end

end

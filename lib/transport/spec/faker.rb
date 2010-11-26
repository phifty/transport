require 'yaml'

module Transport

  module Spec

    # Spec helper class to fake http and json request.
    class Faker

      # This error is raised if no fake request is found for the call.
      class NoFakeRequestError < StandardError; end

      def initialize(transport_class, fakes)
        @transport_class, @fakes = transport_class, fakes
      end

      def stub_requests!
        @transport_class.stub(:request).and_return do |*arguments|
          request *arguments
        end
      end

      private

      def request(http_method, url, options = { })
        parameters, headers, expected_status_code = options.values_at :parameters, :headers, :expected_status_code
        fake = find_fake :http_method => http_method, :url => url, :parameters => parameters, :headers => headers
        response = fake[:response]
        check_status_code response, expected_status_code
        response[:body].dup
      end

      def check_status_code(response, expected_status_code)
        response_code, response_body = response.values_at :code, :body
        raise self.class.unexpected_status_code_error_class.new(
          response_code.to_i,
          response_body
        ) if expected_status_code && expected_status_code.to_s != response_code
      end

      def find_fake(options)
        fake = @fakes.detect{ |fake| self.class.fake_match? fake, options }
        raise NoFakeRequestError, "no fake request found for [#{options[:http_method]} #{options[:url]} #{options[:parameters].inspect} #{options[:headers].inspect}]" unless fake
        fake
      end

      def self.fake_match?(fake, options)
        fake[:http_method].to_s == options[:http_method].to_s &&
          fake[:url].to_s == options[:url].to_s &&
          fake[:parameters] == options[:parameters] &&
          fake[:headers] == options[:headers]
      end

      def self.fake!(type, filename)
        @fake ||= { }
        @fake[type] = YAML.load_file filename
        faker = new transport_class(type), @fake[type]
        faker.stub_requests!
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

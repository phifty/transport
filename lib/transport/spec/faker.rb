require 'yaml'
require 'rspec'

module Transport

  module Spec

    # Spec helper class to fake http and json request.
    class Faker

      TRANSPORT_CLASSES = [
        Transport::HTTP,
        Transport::JSON
      ].freeze unless defined?(TRANSPORT_CLASSES)

      # This error is raised if no fake request is found for the call.
      class NoFakeRequestError < StandardError; end

      def initialize(fakes)
        @fakes = fakes
      end

      def stub_requests!
        TRANSPORT_CLASSES.each do |transport_class|
          stub_requests_for_transport! transport_class
        end
      end

      private

      def stub_requests_for_transport!(transport_class)
        transport_class.stub(:request).and_return do |*arguments|
          request *arguments
        end
      end

      def request(http_method, url, options = { })
        parameters, headers, expected_status_code = options.values_at :parameters, :headers, :expected_status_code
        fake = find_fake :http_method => http_method, :url => url, :parameters => parameters, :headers => headers
        response = fake[:response]
        check_status_code response, expected_status_code
        response[:body].dup
      end

      def check_status_code(response, expected_status_code)
        response_code, response_body = response.values_at :code, :body
        raise Transport::UnexpectedStatusCodeError.new(
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

      def self.fake!(filename)
        faker = new YAML.load_file(filename)
        faker.stub_requests!
      end

    end

  end

end

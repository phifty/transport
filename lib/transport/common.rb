
module Transport

  module Common

    autoload :RequestBuilder, File.join(File.dirname(__FILE__), "common", "request_builder")

    def self.included(base_class)
      base_class.class_eval do
        include InstanceMethods
        extend ClassMethods
      end
    end

    module InstanceMethods

      attr_reader :uri
      attr_reader :request
      attr_reader :options
      attr_reader :response

      def initialize(uri, request, options = { })
        @uri, @request, @options = uri, request, options
      end

    end

    module ClassMethods

      def request(http_method, url, options = { })
        uri, request = RequestBuilder.build http_method, url, options
        transport = new uri, request, options
        transport.perform
        transport.response
      end

    end

  end

end

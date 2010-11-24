require 'uri'

module Transport

  module Common

    module RequestBuilder

      def self.included(base_class)
        base_class.class_eval do
          include InstanceMethods
          extend ClassMethods
        end
      end

      module InstanceMethods

        attr_reader :http_method
        attr_reader :url
        attr_reader :options
        attr_reader :uri

        def initialize(http_method, url, options = { })
          @http_method, @url, @options = http_method, url, options
          @uri = URI.parse @url
        end

      end

      module ClassMethods

        def build(*arguments)
          request_builder = new *arguments
          request_builder.perform
          [ request_builder.uri, request_builder.request ]
        end

      end

    end

  end

end

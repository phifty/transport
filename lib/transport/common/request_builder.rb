require 'uri'

module Transport

  module Common

    module RequestBuilder

      def self.included(base_class)
        base_class.class_eval do
          include InstanceMethods

          def self.build(*arguments)
            request_builder = new *arguments
            request_builder.perform
            [ request_builder.uri, request_builder.request ]
          end

        end
      end

      module InstanceMethods

        HTTP_METHODS_WITH_PARAMETERS = [ :get, :delete, :post, :put ].freeze unless defined?(HTTP_METHODS_WITH_PARAMETERS)
        HTTP_METHODS_WITH_BODY       = [ :post, :put ].freeze unless defined?(HTTP_METHODS_WITH_BODY)

        attr_reader :http_method
        attr_reader :url
        attr_reader :options
        attr_reader :uri

        def initialize(http_method, url, options = { })
          @http_method, @url, @options = http_method, url, options
          @uri = URI.parse @url
        end

      end

    end

  end

end

require 'cgi'

module Transport

  # Common transport layer for http transfers.
  class HTTP

    # Builder for the transport layer requests.
    class RequestBuilder

      # Serializer for transport http parameters.
      class ParameterSerializer

        attr_reader :result

        def initialize(parameters = nil)
          @parameters = parameters || { }
        end

        def perform
          quote_parameters
          serialize_parameters
        end

        private

        def quote_parameters
          @quoted_parameters = { }
          @parameters.each do |key, value|
            encoded_key = CGI.escape(key.to_s)
            @quoted_parameters[encoded_key] = self.class.escape value
          end
        end

        def serialize_parameters
          @result = if @parameters.nil? || @parameters.empty?
            nil
          else
            @quoted_parameters.keys.sort.map do |key|
              self.class.pair key, @quoted_parameters[key]
            end.join("&")
          end
        end

        def self.escape(value)
          value.is_a?(Array) ? value.map{ |element| CGI.escape element.to_s } : CGI.escape(value.to_s)
        end

        def self.pair(key, value)
          value.is_a?(Array) ?
            value.map{ |element| "#{key}=#{element}" }.join("&") :
            "#{key}=#{value}"
        end

      end

    end

  end

end

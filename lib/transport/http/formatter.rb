
module Transport

  # Common transport layer for http transfers.
  class HTTP

    # Formatter for the http request and response objects. Used for log output.
    class Formatter

      # Request formatter.
      class Request

        def initialize(uri, request)
          @uri, @request = uri, request
        end

        def message
          "transport to #{@uri.host} #{@uri.port}\n" +
            request
        end

        private

        def request
          "request: #{@request.class} #{@request.path}\n" +
            request_headers +
            request_body
        end

        def request_headers
          message = ""
          @request.each_capitalized_name do |key|
            message += "    #{key}: #{@request[key]}\n"
          end
          message == "" ? "" : "  headers:\n" + message
        end

        def request_body
          request_body = @request.body
          request_body ? "  body:\n" + Formatter.intend("    #{request_body}", 4) : ""
        end

      end

      # Response formatter.
      class Response

        def initialize(response)
          @response = response
        end

        def message
          message = "response: #{@response.code}\n"
          message += Formatter.intend("  #{@response.body}")
          message
        end

      end

      attr_reader :logger

      def initialize(logger)
        @logger = logger
      end

      def log_transport(uri, request, response)
        log Request.new(uri, request).message + "\n" + Response.new(response).message
      end

      private

      def log(message)
        return unless @logger
        @logger.info message
      end

      def self.intend(message, spaces = 2)
        message.gsub "\n", "\n" + (" " * spaces)
      end

    end

  end

end

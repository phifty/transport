
module Transport

  class HTTP

    module Request

      module Parameter

        autoload :Serializer, File.join(File.dirname(__FILE__), "parameter", "serializer")

      end

    end

  end

end


module Transport

  # The UnexpectedStatusCodeError is raised if the :expected_status_code option is given to
  # the :request method and the responded status code is different from the expected one.
  class UnexpectedStatusCodeError < StandardError

    attr_reader :status_code
    attr_reader :message

    def initialize(status_code, message = nil)
      @status_code, @message = status_code, message
    end

    def to_s
      "#{super} received status code #{self.status_code}" + (@message ? " [#{@message}]" : "")
    end

  end

end

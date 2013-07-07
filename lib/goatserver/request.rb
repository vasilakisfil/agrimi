class Request
  attr_reader :type, :url, :flags

  def initialize(request_string)
    @valid = false
    type, url, flags = request_string.split " "
    if type == "GET" || type == "POST"
      @type, @url, @flags, @valid = type, url, flags, true
    end
  end

  def valid?
    @valid
  end

end


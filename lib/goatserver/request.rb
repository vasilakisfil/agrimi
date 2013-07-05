class Request
  attr_reader :type, :url, :flags

  def initialize(request_string)
   @type, @url, @other = request_string.split " "
  end

end


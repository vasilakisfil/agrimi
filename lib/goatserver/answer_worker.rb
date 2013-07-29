require 'socket'


class AnswerWorker
  attr_reader :request, :response, :serverRoot, :client

  def initialize
    @serverRoot = "/home/vasilakisfil/Development/goat/spec/serverAssets"
  end

  def start(client)
    @client = client

    @request = read_request(@client)

    @response = create_response(@request)

    client.puts @response

    client.close
  end

  private

  def read_request(client)
    request = ""
    while line = client.gets
      request += line
      break if line =~ /^\s*$/
    end
    Request.new(request)
  end

  def create_response(client)

    response = "HTTP/1.1 200 OK\r\nDate: Tue, 14 Dec 2010 10:48:45 GMT\r\n"
    response += "Server: RubyrnContent-Type: text/html charset=iso-8859-1\r\n\r\n"

    filepath = "#{@serverRoot }#{@request.request_uri}"
    if File.exists? filepath
      file = File.open filepath
      response += file.read
      file.close
    else
      response += "Could not find file!"
    end
    return response
  end

end

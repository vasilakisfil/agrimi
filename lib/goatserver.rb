require 'socket'
require 'parseconfig'


class Request
  attr_reader :type, :url, :flags

  def initialize(request_string)
    @type, @url, @other = request_string.split " "
  end
end

class AnswerWorker
  attr_reader :request, :response, :serverRoot

  def initialize
    @serverRoot = "/home/vasilakisfil/Development/goat/spec/serverAssets"
  end

  def start(client)
    request = ""
    while line = client.gets
      request += line
      break if line =~ /^\s*$/
    end
    @request = Request.new(request)

    # puts request

    @response = "HTTP/1.1 200 OK\r\nDate: Tue, 14 Dec 2010 10:48:45 GMT\r\n"
    @response += "Server: RubyrnContent-Type: text/html charset=iso-8859-1\r\n\r\n"

    client.puts @response
    filepath = "#{@serverRoot }#{@request.url}"
    if File.exists? filepath
      file = File.open filepath
      client.puts file.read
      file.close
    else
      client.puts "Could not find file!"
    end
    client.close
  end

end


class Goatserver
  attr_reader :configPath, :serverRoot, :port

  def initialize(port)
    @port = port
    @serverRoot = "/home/vasilakisfil/Development/goat/spec/serverAssets"
  end

  def start
    @server = TCPServer.new(@port)
    client = nil
    loop {
      answerWorker = AnswerWorker.new
      client = @server.accept

      # Initiate new Actor to handle the request
      answerWorker.start(client)
    }
    @server.close
  end
end

server = Goatserver.new(5060)
server.start


require 'socket'


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

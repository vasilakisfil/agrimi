require 'socket'
require 'parseconfig'


class Goatserver
  attr_reader :configPath, :serverRoot, :port

  def initialize(port)
    @port = port
    @serverRoot = "/home/vasilakisfil/Development/goat/spec/serverAssets"
  end

  def start
    @server = TCPServer.new(@port)
    client = nil

    client = @server.accept

    request = ''
    while line = client.gets
      request += line
      break if line =~ /^\s*$/
    end

    puts request
    file = File.open "#{@serverRoot }/index.html"
    client.puts "HTTP/1.1 200 OK\r\nDate: Tue, 14 Dec 2010 10:48:45 GMT\r\n
                Server: RubyrnContent-Type: text/html;
                charset=iso-8859-1\r\n\r\n"
    client.puts file.read
    file.rewind
    puts file.read
    file.close
    client.close
  end
end

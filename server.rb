require 'socket'
require 'parseconfig'

class GoatServer
  attr_reader :serverRoot, :port

  def initialize(port, configPath=nil)
    @port = port
    if !configPath
      configPath = "goat.conf"
    end
     
    config = ParseConfig.new(configPath)
    serverRoot = config['serverRoot']
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
    client.close
  end
end

gs = GoatServer.new 5000 
gs.start

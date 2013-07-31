require 'socket'
require 'parseconfig'
require 'celluloid'

require_relative 'goatserver/answer_worker'
require_relative 'goatserver/request'
require_relative 'goatserver/response'

class Goatserver
  attr_reader :config_path, :server_root, :port
  include Celluloid

  def initialize(port)
    @port = port
    @server_poot = "/home/vasilakisfil/Development/goat/spec/serverAssets"
  end

  def start
    puts "Opening server"
    @server = TCPServer.new(@port)
    pool = AnswerWorker.pool(size: 2)
    client = nil
    loop do
      client = @server.accept
      # Initiate new Actor to handle the request
      pool.start(client)
    end
    stop
  end

  def stop
    puts "Closing server"
    @server.close
  end
end



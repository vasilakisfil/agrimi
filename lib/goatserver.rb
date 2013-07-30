require 'socket'
require 'parseconfig'

require_relative 'goatserver/answer_worker.rb'
require_relative 'goatserver/request.rb'
require_relative 'goatserver/response.rb'

class Goatserver
  attr_reader :configPath, :serverRoot, :port

  def initialize(port)
    @port = port
    @serverRoot = "/home/vasilakisfil/Development/goat/spec/serverAssets"
  end

  def start
    puts "Opening server"
    @server = TCPServer.new(@port)
    client = nil
    loop do
      answerWorker = AnswerWorker.new
      client = @server.accept
      # Initiate new Actor to handle the request
      answerWorker.start(client)
    end
    stop
  end

  def stop
    puts "Closing server"
    @server.close
  end
end



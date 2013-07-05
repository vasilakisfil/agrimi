require 'socket'
require 'parseconfig'

require_relative 'goatserver/answer_worker.rb'
require_relative 'goatserver/request.rb'

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



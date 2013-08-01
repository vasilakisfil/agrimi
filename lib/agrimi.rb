require 'socket'
require 'parseconfig'
require 'celluloid'
require 'celluloid/autostart'

require_relative 'agrimi/answer_worker'
require_relative 'agrimi/request'
require_relative 'agrimi/response'

module Agrimi
  class HTTPServer
    attr_reader :config_path, :server_root, :port
    include Celluloid

    def initialize(port)
      @port = port
      @server_poot = "/home/vasilakisfil/Development/agrimi/spec/serverAssets"
    end

    def start
      puts "Opening server"
      @server = TCPServer.new(@port)
      Celluloid::Actor[:accept_pool] = AnswerWorker.pool(size: 2)
      client = nil
      loop do
        client = @server.accept
        # Initiate new Actor to handle the request
        Celluloid::Actor[:accept_pool].start(client)
      end
      stop
    end

    def stop
      puts "Closing server"
      @server.close
      Celluloid::Actor[:accept_pool].terminate
      exit
    end
  end
end



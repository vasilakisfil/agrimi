require 'socket'
require 'parseconfig'
require 'celluloid/io'
require 'celluloid/autostart'

require_relative 'agrimi/answer_worker'
require_relative 'agrimi/request'
require_relative 'agrimi/response'

module Agrimi
  class HTTPServer
    attr_reader :config_path, :server_root, :port
    include Celluloid::IO

    def initialize(port)
      @port = port
      @server_root = "/home/vasilakisfil/Development/agrimi/spec/server_assets"
    end

    def start
      puts "Opening server"
      @tcp_server = TCPServer.new("0.0.0.0", @port)
      @pool = AnswerWorker.pool(size: 2)
      answer_worker = AnswerWorker.new
      client = nil
      loop do
        client = @tcp_server.accept
        puts "Server accepted"
        # Initiate new Actor to handle the request
        @pool.async.start(client)
      end
      stop
    end

    def stop
      puts "Closing server"
      @tcp_server.close
      @pool.terminate
    end
  end
end



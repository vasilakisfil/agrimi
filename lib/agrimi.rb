require 'socket'
require 'parseconfig'
require 'logger'
require 'celluloid/io'
require 'celluloid/autostart'


require_relative 'agrimi/answer_worker'
require_relative 'agrimi/request'
require_relative 'agrimi/response'

module Agrimi

  # Starts and initiates the HTTP server

  class HTTPServer
    attr_reader :config_path, :server_root, :port
    include Celluloid::IO

    # Initializes the HTTP server
    #
    # @param port [Integer] The port the server listens to
    # @param server_root [String] The directory the server points to
    def initialize(port, server_root)
      @logger = ::Logger.new(STDOUT)
      @logger.level = ::Logger::DEBUG
      @port = port
      @server_root = server_root
    end

    # Starts the server ready to accept new connections
    def start
      @logger.debug { "Opening server" }
      @tcp_server = TCPServer.new("0.0.0.0", @port)
      @logger.debug { "Listening to 0.0.0.0 port #{@port}
                      pointing #{@server_root}" }
      @pool = AnswerWorker.pool(size: 2)
      answer_worker = AnswerWorker.new
      client = nil
      loop do
        client = @tcp_server.accept
        @logger.debug { "Server accepted" }
        # Initiate new Actor to handle the request
        @pool.async.start(client, @server_root)
      end
      stop
    end

    # TO DO Close all sockets for every actor and then close server
=begin
    def stop
      @tcp_server.close
      @logger.debug { "Server Closed" }
    end
=end
  end
end



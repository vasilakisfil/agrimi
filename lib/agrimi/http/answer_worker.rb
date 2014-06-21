require 'socket'
require 'celluloid/io'
require 'celluloid/autostart'
require 'logger'

module Agrimi::HTTP
  # AnswerWorker handles each new request. Currently it handles only one request
  # per connection but in the future it will implement HTTP keep-alive too.
  class AnswerWorker
    attr_reader :request, :response, :server_root, :client
    include Celluloid::IO

    # Initializes the AnswerWorker
    def initialize
      @logger = ::Logger.new(STDOUT)
      @logger.level = ::Logger::INFO
    end

    # Starts the AnswerWorker.
    #
    # @param client [tcpsocket] The tcp socket of the client
    # @param server_root [string] The directory that the server points to
    def start(client, server_root)
      request = Request.new(read_input(client))

      status, headers, body = Agrimi::HTTP::Server.app.call(request.rack_env)

      response = Response.new(status, headers, body)

      client.puts response.to_s
      client.close
    end

    private
      # Reads the HTTP request from a tcpsocket
      #
      # @param client [tcpsocket] The tcp socket from which the request will
      # be read
      # @return [Request] The Request object with the request sring
      def read_input(client)
        request = ""
        while line = client.gets
          request += line
          break if line =~ /^\s*$/
        end

        return request
      end
  end
end

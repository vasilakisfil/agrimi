require 'socket'
require 'celluloid/io'
require 'celluloid/autostart'
require 'logger'

module Agrimi
  # AnswerWorker handles each new request. Currently it handles only one request
  # per connection but in the future it will implement HTTP keep-alive too.
  class AnswerWorker
    attr_reader :request, :response, :server_root, :client
    include Celluloid::IO

    # Initializes the AnswerWorker
    def initialize
      @logger = ::Logger.new(STDOUT)
      @logger.level = ::Logger::DEBUG
    end

    # Starts the AnswerWorker.
    #
    # @param client [tcpsocket] The tcp socket of the client
    # @param server_root [string] The directory that the server points to
    def start(client, server_root)
      @client = client
      @server_root = server_root
      #loop do
        @request = read_request(@client)

        @response = create_response(@request)

        client.puts @response
      #end
      client.close
    end

    private

    # Reads the HTTP request from a tcpsocket
    #
    # @param client [tcpsocket] The tcp socket from which the request will
    # be read
    # @return [Request] The Request object with the request sring
    def read_request(client)
      request = ""
      while line = client.gets
        request += line
        break if line =~ /^\s*$/
      end
      Request.new(request)
    end

    # Creates a new respons according to the given request
    # @param request [String] The HTTP request string
    # @return [Response] The HTTP response as a string
    def create_response(request)
      response = Response.new
      response.header_field[:Connection] = ""
      filepath = "#{@server_root}#{request.request_uri}"
      if File.exists? filepath
        case request.request_uri
        when /\.(?:html)$/i
          file = File.open filepath
          response.body = file.read
          response.header_field[:'Content-Type'] = "text/html; charset=utf-8"
          file.close
        when /\.(?:css)$/i
          file = File.open filepath
          response.body = file.read
          response.header_field[:'Content-Type'] = "text/css"
          file.close
        when /\.(?:js)$/i
          file = File.open filepath
          response.body = file.read
          response.header_field[:'Content-Type'] = "text/javascript"
          file.close
        when /\.(?:jpg)$/i
          file = File.open(filepath, "rb")
          response.body = file.read
          response.header_field[:'Accept-Ranges'] = "bytes"
          response.header_field[:'Content-Type'] = "image/jpeg"
          file.close
        when /\.(?:png)$/i
          file = File.open(filepath, "rb")
          response.body = file.read
          response.header_field[:'Accept-Ranges'] = "bytes"
          response.header_field[:'Content-Type'] = "image/png"
          file.close
        else
          response.body = "Wrong file!"
        end
      else
        response.body = "Could not find file!"
      end

      response.to_s
    end
  end
end

require 'socket'
require 'celluloid/io'
require 'celluloid/autostart'

module Agrimi
  class AnswerWorker
    attr_reader :request, :response, :server_root, :client
    include Celluloid::IO

    def initialize
      @server_root = "/home/vasilakisfil/Development/sofia/"
      #@server_root = "/home/vasilakisfil/Development/agrimi/spec/server_assets"
    end

    def start(client)
      @client = client
      loop do
        @request = read_request(@client)

        @response = create_response(@request)

        client.puts @response
      end
      client.close
    end

    private

    def read_request(client)
      request = ""
      while line = client.gets
        request += line
        break if line =~ /^\s*$/
      end
      Request.new(request)
    end

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

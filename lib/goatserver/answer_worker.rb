require 'socket'
require 'celluloid'


class AnswerWorker
  attr_reader :request, :response, :server_root, :client
  include Celluloid

  def initialize
    @server_root = "/home/vasilakisfil/Development/goat/spec/serverAssets"
  end

  def start(client)
    @client = client

    @request = read_request(@client)

    @response = create_response(@request)

    client.puts @response

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

    filepath = "#{@server_root}#{request.request_uri}"
    if File.exists? filepath
      file = File.open filepath
      response.body = file.read
      file.close
    else
      response.body = "Could not find file!"
    end

    return response.return_now
  end

end

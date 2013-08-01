require 'spec_helper'
require 'tempfile'
require 'rest-client'



describe Agrimi::Request do
  before(:all) do
    good_req_str = "GET /index.html HTTP/1.1\n"
    good_req_str += "Host: www.example.com\r\n"
    @good_req = Agrimi::Request.new(good_req_str)

    bad_req_str_meth = "MEH /index.html HTTP/1.1\n"
    bad_req_str_meth += "Host: www.example.com\r\n"
    @bad_req = Agrimi::Request.new(bad_req_str_meth)
  end

  context "with valid data" do
    it "splits them accordingly" do
      expect(@good_req.method).to eq('GET')
      expect(@good_req.request_uri).to eq('/index.html')
      expect(@good_req.valid?).to be_true
    end
  end

  context "with invalid data" do
    it "returns false #valid?" do
      expect(@bad_req.valid?).to be_false
    end
  end
end

describe Agrimi::Response do
  before(:all) do
   @response = Agrimi::Response.new
  end

  it "'s basic fields initialized correctly" do
    expect(@response.status_line).to  eq("HTTP/1.1 200 OK")
    expect(@response.header_field[:Server]).to include("GoatServer")
  end
end

describe Agrimi::HTTPServer do

  before do
    @serverAssets = "#{Dir.getwd}/spec/serverAssets"
    @port = 5555
    @server = Agrimi::HTTPServer.new(@port)
    sleep(1)
  end

  context "with full initializer" do
    before do
      # configFilePath = "#{Dir.getwd}/spec/serverAssets/goat.conf"
    end

    it "sets the right conf file and port" do
      # expect(@server.serverRoot).to eq("#{Dir.getwd}/spec/serverAssets")
      expect(@server.port).to eq(@port)
    end
  end

  context "Requesting a page by GET" do
    before do
      @server_thread = Thread.new { @server.start }
      # wait for server to initialize
      sleep(1)
    end

    after do
    #  sleep(1)
    # @server.stop

      @server_thread.kill
    end

    it "shows the html code" do
      htmlFile = "index.html"
      link = "http://localhost:#{@port}/#{htmlFile}"
      response = RestClient.get link
      expect(response.to_str).to eq(File.open("#{@serverAssets}/#{htmlFile}")
                                        .read)
    end
  end

end

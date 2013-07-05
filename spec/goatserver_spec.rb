require 'spec_helper'
require 'tempfile'
require 'rest-client'



describe "Request" do
  before(:all) do
    good_req_str = "GET /index.html HTTP/1.1\n"
    good_req_str += "Host: www.example.com\r\n"
    @good_req = Request.new(good_req_str)

    bad_req_str_meth = "MEH /index.html HTTP/1.1\n"
    bad_req_str_meth += "Host: www.example.com\r\n"
    @bad_req_meth = Request.new(bar_req_str_meth)
  end

  context "with valid data" do
    it "splits them accordingly" do
      expect(@good_req.type).to eq('GET')
      expect(@good_req.url).to eq('/index.html')
    end
  end

  context "with invalid data" do
    pending "write test!"
  end
end

describe "Goatserver" do

  before(:all) do
    @serverAssets = "#{Dir.getwd}/spec/serverAssets"
    @port = 5060
    # configFilePath = "#{Dir.getwd}/spec/serverAssets/goat.conf"
    @server = Goatserver.new(@port)
    Thread.new { @server.start }
  end

  context "with full initializer" do
    it "sets the right conf file and port" do
      # expect(@server.serverRoot).to eq("#{Dir.getwd}/spec/serverAssets")
      expect(@server.port).to eq(@port)
    end
  end

  context "Requesting a page by GET" do
    it "shows the html code" do
      htmlFile = "index.html"
      link = "http://localhost:#{@port}/#{htmlFile}"
      response = RestClient.get link
      expect(response.to_str).to eq(File.open("#{@serverAssets}/#{htmlFile}")
                                        .read)
    end
  end

end

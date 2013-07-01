require 'spec_helper'
require 'tempfile'
require 'rest-client'

describe "Goatserver" do

  before do
    # configFilePath = "#{Dir.getwd}/spec/serverAssets/goat.conf"
    @server = Goatserver.new(5050)
    Thread.new { @server.start }
  end

  context "with full initializer" do
    it "sets the right conf file and port" do
      # expect(@server.serverRoot).to eq("#{Dir.getwd}/spec/serverAssets")
      expect(@server.port).to eq(5050)
    end
  end

  context "Requesting a page by GET" do
    it "shows the html code" do
      htmlFile = "index.html"
      response = RestClient.get 'http://localhost:5050/index.html'
      expect(response.to_s).to eq(htmlFile)
    end
  end

end

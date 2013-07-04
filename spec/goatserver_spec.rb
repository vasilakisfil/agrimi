require 'spec_helper'
require 'tempfile'
require 'rest-client'



describe "AnswerActor" do
  before do

  end

  context "with valid client" do


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

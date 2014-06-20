require 'rack'
require_relative '../agrimi'



module Rack
  module Handler
    class HTTPServer

      def self.run(app)
        @app = app
        path = '/home/vasilakisfil/Development/sofia/'
        server = Agrimi::HTTPServer.new(8000, path, @app)
        server.start
      end
    end
  end
end

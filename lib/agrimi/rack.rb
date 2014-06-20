require 'rack'
require_relative '../agrimi'

module Rack
  module Handler
    class HTTPServer

      def self.run(app)
        @app = app
        server = Agrimi::HTTPServer.new(8000, '', @app)
        server.start
      end
    end
  end
end

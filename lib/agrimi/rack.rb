require 'rack'
require_relative '../agrimi'

module Rack
  module Handler
    class Agrimi

      def self.run(app)
        @app = app
        server = ::Agrimi::HTTP::Server.new(8000, '', @app)
        server.start
      end
    end
  end
end

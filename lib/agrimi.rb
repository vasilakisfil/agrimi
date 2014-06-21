require 'socket'
require 'parseconfig'
require 'logger'
require 'celluloid/io'
require 'celluloid/autostart'

module Agrimi
  module HTTP
  end
end

require_relative 'agrimi/http/server'
require_relative 'agrimi/http/answer_worker'
require_relative 'agrimi/http/request'
require_relative 'agrimi/http/response'




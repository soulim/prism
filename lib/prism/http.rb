require 'evma_httpserver'

module Prism
  class Http < EventMachine::Connection
    include EM::HttpServer
    
    def set_callbacks
    end
  end
end
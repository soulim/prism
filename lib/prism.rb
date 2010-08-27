$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'eventmachine'
require 'prism/web_socket'
require 'prism/http'

module Prism
  class << self
    attr_accessor :websocket, :http, :key, :secret
  end
  
  # Start Prism
  #
  # Example
  # Prism.start do |config|
  #   config.websocket  = { :host => '0.0.0.0', :port => 8080, :debug => true }
  #   config.http       = { :host => '0.0.0.0', :port => 8081, :debug => true }
  #   config.key        = 'key'
  #   config.secret     = 'secret'
  # end  
  def self.start(&block)
    yield(self) if block_given?
    
    EM.epoll
    EM.run do
      trap("TERM") { self.stop }
      trap("INT")  { self.stop }
      # start WebSocket server
      EM::start_server(self.websocket[:host], self.websocket[:port], Prism::WebSocket, self.websocket) do |connection|
        connection.set_callbacks
      end
      # start HTTP server
      EM::start_server(self.http[:host], self.http[:port], Prism::Http, self.http) do |connection|
        connection.set_callbacks
      end
    end
  end
  
  # Stop Prism
  def self.stop
    EM.stop
  end
  
end

#Prism.start do |config|
#  config.websocket  = { :host => '0.0.0.0', :port => 8080, :debug => true }
#  config.http       = { :host => '0.0.0.0', :port => 8081, :debug => true }
#  config.key        = 'key'
#  config.secret     = 'secret'
#end  

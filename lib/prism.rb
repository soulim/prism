$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'eventmachine'
require 'prism/web_socket'

module Prism
  class << self
    attr_accessor :websocket, :http, :key, :secret
  end
  
  
  # Example
  # Prism.start do |config|
  #   config.websocket  = { :host => '127.0.0.1', :port => 8080, :debug => true }
  #   config.http       = { :host => '127.0.0.1', :port => 8081, :debug => true }
  #   config.key        = 'key'
  #   config.secret     = 'secret'
  # end  
  def self.start(&block)
    yield(self) if block_given?
    
    EM.epoll
    EM.run do
    end
  end
  
  def self.stop
    EM.stop
  end
  
end
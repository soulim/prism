require 'rubygems'
require 'eventmachine'
require 'prism/web_socket'
require 'prism/http'
require 'cgi'
require 'logger'

module Prism
  class << self
    attr_accessor :websocket, :http, :key, :secret, :debug
    
    def logger
      @logger ||= begin
        log = Logger.new(STDOUT)
        log.level = Logger::INFO
        log
      end
    end
  end
  
  # Start Prism
  #
  # Example
  # Prism.start do |config|
  #   config.websocket  = { :host => '0.0.0.0', :port => 8080 }
  #   config.http       = { :host => '0.0.0.0', :port => 8081 }
  #   config.key        = 'key'
  #   config.secret     = 'secret'
  #   config.debug      = true
  # end  
  def self.start(&block)
    yield(self) if block_given?
    
    EM.epoll
    EM.run do
      trap("TERM") { self.stop }
      trap("INT")  { self.stop }
      # start WebSocket server
      EM::start_server(self.websocket[:host], self.websocket[:port], Prism::WebSocket, self.websocket.merge(:debug => self.debug)) do |connection|
        connection.set_callbacks
      end
      # start HTTP server
      EM::start_server(self.http[:host], self.http[:port], Prism::Http, self.http.merge(:debug => self.debug)) do |connection|
        connection.set_callbacks
      end
    end
  end
  
  # Stop Prism
  def self.stop
    EM.stop
  end
  
  def self.[](name)
    @channels ||= {}
    @channels[name.to_s] ||= EM::Channel.new
  end
  
  def self.authenticate(method, path, query)
    query   = CGI.parse(query).inject({}){ |hash, (key, value)| hash[key] = value.first;hash } if query.is_a?(String)
    
    token   = Signature::Token.new(Prism.key, Prism.secret)
    request = Signature::Request.new(method, path, query)
    
    return request.authenticate_by_token(token)
  end
end
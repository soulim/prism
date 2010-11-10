require 'rubygems'
require 'eventmachine'
require 'prism/web_socket'
require 'cgi'
require 'logger'

module Prism
  class << self
    attr_accessor :host, :port, :key, :secret, :debug
    
    def logger
      @logger ||= begin
        log = Logger.new(STDOUT)
        log.level = Logger::INFO
        log
      end
    end
  end
  
  def self.start(&block)
    yield(self) if block_given?
    
    EM.epoll
    EM.run do
      trap("TERM") { self.stop }
      trap("INT")  { self.stop }

      EM::start_server(self.host, self.port, Prism::WebSocket, { :host => self.host, :port => self.port, :debug => self.debug }) do |connection|
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
    
    return request.authenticate_by_token(token, nil)
  end
end
require 'em-websocket'

module Prism
  class WebSocket < EventMachine::WebSocket::Connection
    def set_callbacks
      self.onopen     { puts "open" }
      self.onclose    { puts "close" }
      self.onmessage  { |message| puts "message: #{message}" }
    end
  end
end
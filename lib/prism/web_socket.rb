require 'em-websocket'
require 'signature'
require 'uri'

module Prism
  class WebSocket < EventMachine::WebSocket::Connection
    attr_reader :sid, :channel_name
    
    def set_callbacks
      self.onopen     { subscibe_on_channel }
      self.onclose    { unsubscibe_from_channel }
      self.onerror    { |error| self.send(error) }
      #self.onmessage  { |message|  }
    end
    
    def process_unauthorized_request(reason)
      @onerror.call(reason) if @onerror
      send_data "HTTP/1.1 401 Unauthorized\r\n\r\n"
      close_connection_after_writing
    end
    
    protected
    
    def subscibe_on_channel
      request = parse_request

      if Prism.authenticate('WS', request[:path], request[:query])
        @channel_name = request[:path]
        @sid = Prism[@channel_name].subscribe{ |channel_message| self.send(channel_message) }
        return true
      else
        Prism.logger.error "[Authentication error] #{request.inspect}"
        self.process_unauthorized_request("Unauthorized access")
        return false
      end
    end

    def unsubscibe_from_channel
      Prism[channel_name].unsubscribe(sid) unless sid.nil?
      @sid          = nil
      @channel_name = nil
    end
    
    def parse_request
      params = {}

      params[:path] = begin
        URI.parse(self.request['Path']).path
      rescue Exception => e
        Prism.logger.error "[Request parse error] #{e}"
        self.process_bad_request("Bad request")
      end
      params[:query] = self.request['Query']
      
      return params
    end    
  end
end
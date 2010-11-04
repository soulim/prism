require 'evma_httpserver'

module Prism
  class Http < EventMachine::Connection
    include EM::HttpServer
    
    # callback
    def onmessage(&block); @onmessage = block; end
    
    def set_callbacks
      self.onmessage  { |channel_name, message| Prism[channel_name].push(message) }
    end

    def post_init
      super
      no_environment_strings
    end

    def process_http_request
      response = EM::DelegatedHttpResponse.new(self)
      
      if !Prism.authenticate(@http_request_method, @http_path_info, @http_query_string)
        response.status = 401
      elsif !valid_request?
        response.status = 400
      else
        response.status = 202
        Prism.logger.info "[Prism::Http] onmessage(#{@http_path_info}, #{@http_post_content})"
        @onmessage.call(@http_path_info, @http_post_content)
      end
      
      response.send_response        
    end
    
    def valid_request?
      ('POST' == @http_request_method) && (@http_content_type =~ /application\/json/)
    end
  end
end
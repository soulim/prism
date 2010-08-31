require 'spec_helper'

module Prism
  describe Http do
    subject     { Http }
    let(:host)  { '0.0.0.0' }
    let(:port)  { 12345 }
    let(:url)   { "http://127.0.0.1:#{port}" }
    
    describe '#set_callbacks' do
      it 'sets #onmessage callback' do
        EM.run do
          EventMachine.add_timer(0.1) do
            http = EventMachine::HttpRequest.new(url).get :timeout => 0
            http.callback { http.close_connection }
          end
          EM::start_server(host, port, subject, {}) do |c|
            c.should_receive(:onmessage)
            c.set_callbacks
            EM.stop
          end
        end
      end
    end
    
    describe '#process_http_request' do
      it 'authenticates request' do
        EM.run do
          EventMachine.add_timer(0.1) do
            http = EventMachine::HttpRequest.new(url).post :timeout => 0
            http.callback { http.close_connection; EM.stop }
          end
          Prism.should_receive(:authenticate)
          EM::start_server(host, port, subject, {})
        end        
      end
      
      it 'validates request' do
        EM.run do
          EventMachine.add_timer(0.1) do
            http = EventMachine::HttpRequest.new(url).post :timeout => 0
            http.callback { http.close_connection; EM.stop }
          end
          
          EM::start_server(host, port, subject, {}) do |c|
            Prism.stub!(:authenticate).and_return(true)
            
            c.should_receive(:valid_request?)
          end
        end        
      end
      
      context 'when authorized access with valid request' do
        it 'returns 202 Accepted status' do
          EM.run do
            EventMachine.add_timer(0.1) do
              http = EventMachine::HttpRequest.new(url).post :timeout => 0
              http.callback {
                http.close_connection
                EM.stop
                http.response_header.status.should == 202
              }
            end
            EM::start_server(host, port, subject, {}) do |c|
              Prism.stub!(:authenticate).and_return(true)
              c.stub!(:valid_request?).and_return(true)
              c.set_callbacks
            end
          end        
        end
      end
      
      context 'when unauthorized access' do
        it 'returns 401 Unauthorized status' do
          EM.run do
            EventMachine.add_timer(0.1) do
              http = EventMachine::HttpRequest.new(url).post :timeout => 0
              http.callback {
                http.close_connection
                EM.stop
                http.response_header.status.should == 401
              }
            end
            EM::start_server(host, port, subject, {}) do |c|
              Prism.stub!(:authenticate).and_return(false)
              c.stub!(:valid_request?).and_return(true)
              c.set_callbacks
            end
          end        
        end
      end
      
      context 'when not valid request' do
        it 'returns 400 Bad Request status' do
          EM.run do
            EventMachine.add_timer(0.1) do
              http = EventMachine::HttpRequest.new(url).post :timeout => 0
              http.callback {
                http.close_connection
                EM.stop
                http.response_header.status.should == 400
              }
            end
            EM::start_server(host, port, subject, {}) do |c|
              Prism.stub!(:authenticate).and_return(true)
              c.stub!(:valid_request?).and_return(false)
              c.set_callbacks
            end
          end        
        end
      end
    end
  end
end
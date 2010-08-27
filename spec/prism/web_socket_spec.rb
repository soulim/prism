require 'spec_helper'

module Prism
  describe WebSocket do
    subject     { WebSocket }
    let(:host)  { '0.0.0.0' }
    let(:port)  { 12345 }
    let(:url)   { "ws://127.0.0.1:#{port}" }
    
    describe '#set_callbacks' do
      it 'sets #onopen callback' do
        EM.run do
          EM::start_server(host, port, subject, {}) do |c|
            c.should_receive(:onopen)
            c.set_callbacks
          end
          http = EventMachine::HttpRequest.new(url).get :timeout => 0
          EM.stop
        end
      end
      
      it 'sets #onclose callback' do
        EM.run do
          EM::start_server(host, port, subject, {}) do |c|
            c.should_receive(:onclose)
            c.set_callbacks
          end
          http = EventMachine::HttpRequest.new(url).get :timeout => 0
          EM.stop
        end
      end

      it 'sets #onmessage callback' do
        EM.run do
          EM::start_server(host, port, subject, {}) do |c|
            c.should_receive(:onmessage)
            c.set_callbacks
          end
          http = EventMachine::HttpRequest.new(url).get :timeout => 0
          EM.stop
        end
      end
    end
  end
end
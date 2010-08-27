require 'spec_helper'

describe Prism do
  subject { Prism }
  before(:each) { EM.stub!(:run) }
  
  describe '.start' do
    it 'inits EM epoll' do
      EM.should_receive(:epoll)
      subject.start
    end

    it 'runs EM reactor' do
      EM.should_receive(:run)
      subject.start
    end
    
    it 'starts WebSocket server'
    it 'starts HTTP server'
    
    context 'when block given' do
      before(:each) do
        subject.start do |config|
          config.websocket  = { :host => '0.0.0.0', :port => 8080, :debug => true }
          config.http       = { :host => '0.0.0.0', :port => 8081, :debug => true }
          config.key        = 'key'
          config.secret     = 'secret'
        end        
      end
      
      it 'sets websocket config' do
        subject.websocket.should_not be_nil
      end
      
      it 'sets http config' do
        subject.http.should_not be_nil
      end
      
      it 'sets key' do
        subject.key.should_not be_nil
      end
      
      it 'sets secret' do
        subject.secret.should_not be_nil
      end
    end
  end
  
  describe '.stop' do
    it 'stops EM reactor' do
      EM.should_receive(:stop)
      subject.stop
    end
  end
end
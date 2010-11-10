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
    
    context 'when block given' do
      before(:each) do
        subject.start do |config|
          config.host   = '0.0.0.0'
          config.port   = 8080
          config.debug  = false
          config.key    = 'key'
          config.secret = 'secret'
        end        
      end
      
      it 'sets host' do
        subject.host.should_not be_nil
      end
      
      it 'sets port' do
        subject.port.should_not be_nil
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
  
  describe '.[]' do
    it 'returns EM::Channel' do
      subject['foo'].should be_an_instance_of(EM::Channel)
    end
  end
  
  describe '.authenticate' do
    it 'authenticate request'
  end    
end
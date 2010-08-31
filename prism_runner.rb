require 'lib/prism'

Prism.start do |config|
  config.websocket  = { :host => '0.0.0.0', :port => 8080, :debug => false }
  config.http       = { :host => '0.0.0.0', :port => 8081, :debug => false }
  config.key        = 'key'
  config.secret     = 'secret'
end  

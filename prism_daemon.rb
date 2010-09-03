require 'rubygems'
require 'daemons'

Daemons.run('prism_runner.rb', :monitor => true)
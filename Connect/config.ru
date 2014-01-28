#!/usr/bin/env ruby
require 'rubygems'
require 'bundler'
Bundler.require

ROOT_PATH = File.expand_path(File.dirname(__FILE__))

if ENV['DEBUG'] == 'yes'
  ENV['APP_TYPE'] = 'rhosync'
  ENV['ROOT_PATH'] = ROOT_PATH
  require 'debugger'
end

require 'rhoconnect/server'
require 'rhoconnect/web-console/server'
require 'resque/server'

# Rhoconnect server flags
#Rhoconnect::Server.enable  :stats
Rhoconnect::Server.disable :run
Rhoconnect::Server.disable :clean_trace
Rhoconnect::Server.enable  :raise_errors
Rhoconnect::Server.set     :secret,      '3e98f5b8572ed5c92abd1adb84dbd76518ce67a6d1395eba9d227432f5101514c98aed99330678d25bd98e752aa894952769423b5e519d3f158d324b2a5601cc'
Rhoconnect::Server.set     :root,        ROOT_PATH
Rhoconnect::Server.use     Rack::Static, :urls => ['/data'], :root => Rhoconnect::Server.root
# disable Async mode if Debugger is used
if ENV['DEBUG'] == 'yes'
  Rhoconnect::Server.set :use_async_model, false
end

# Load our rhoconnect application
require './application'

# Setup the url map
run Rack::URLMap.new \
	'/'         => Rhoconnect::Server.new,
	'/resque'   => Resque::Server.new, # If you don't want resque frontend, disable it here
	'/console'  => RhoconnectConsole::Server.new # If you don't want rhoconnect frontend, disable it here
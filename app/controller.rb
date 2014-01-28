require 'rho'
require 'rho/rhocontroller'
require 'rho/rhoerror'
require 'helpers/browser_helper'

class AppController < Rho::RhoController
  include BrowserHelper
  
  def index     
    rendirect :controller => :Auto, :action => :inp_location
  end
  
end
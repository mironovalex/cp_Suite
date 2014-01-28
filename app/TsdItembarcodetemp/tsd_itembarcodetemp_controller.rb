require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TsdItembarcodetempController < Rho::RhoController
  include BrowserHelper

  # GET /TsdItembarcodetemp
  def index
    @tsditembarcodetemps = TsdItembarcodetemp.find(:all)
    render :back => '/app'
  end

  # GET /TsdItembarcodetemp/{1}
  def show
    @tsditembarcodetemp = TsdItembarcodetemp.find(@params['id'])
    if @tsditembarcodetemp
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /TsdItembarcodetemp/new
  def new
    @tsditembarcodetemp = TsdItembarcodetemp.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /TsdItembarcodetemp/{1}/edit
  def edit
    @tsditembarcodetemp = TsdItembarcodetemp.find(@params['id'])
    if @tsditembarcodetemp
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /TsdItembarcodetemp/create
  def create
    @tsditembarcodetemp = TsdItembarcodetemp.create(@params['tsditembarcodetemp'])
    redirect :action => :index
  end

  # POST /TsdItembarcodetemp/{1}/update
  def update
    @tsditembarcodetemp = TsdItembarcodetemp.find(@params['id'])
    @tsditembarcodetemp.update_attributes(@params['tsditembarcodetemp']) if @tsditembarcodetemp
    redirect :action => :index
  end

  # POST /TsdItembarcodetemp/{1}/delete
  def delete
    @tsditembarcodetemp = TsdItembarcodetemp.find(@params['id'])
    @tsditembarcodetemp.destroy if @tsditembarcodetemp
    redirect :action => :index  
  end
end

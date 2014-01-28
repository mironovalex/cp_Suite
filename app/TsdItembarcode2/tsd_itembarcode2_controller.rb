require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TsdItembarcode2Controller < Rho::RhoController
  include BrowserHelper

  # GET /TsdItembarcode2
  def index
    @tsditembarcode2s = TsdItembarcode2.find(:all)
    render :back => '/app'
  end

  # GET /TsdItembarcode2/{1}
  def show
    @tsditembarcode2 = TsdItembarcode2.find(@params['id'])
    if @tsditembarcode2
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /TsdItembarcode2/new
  def new
    @tsditembarcode2 = TsdItembarcode2.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /TsdItembarcode2/{1}/edit
  def edit
    @tsditembarcode2 = TsdItembarcode2.find(@params['id'])
    if @tsditembarcode2
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /TsdItembarcode2/create
  def create
    @tsditembarcode2 = TsdItembarcode2.create(@params['tsditembarcode2'])
    redirect :action => :index
  end

  # POST /TsdItembarcode2/{1}/update
  def update
    @tsditembarcode2 = TsdItembarcode2.find(@params['id'])
    @tsditembarcode2.update_attributes(@params['tsditembarcode2']) if @tsditembarcode2
    redirect :action => :index
  end

  # POST /TsdItembarcode2/{1}/delete
  def delete
    @tsditembarcode2 = TsdItembarcode2.find(@params['id'])
    @tsditembarcode2.destroy if @tsditembarcode2
    redirect :action => :index  
  end
end

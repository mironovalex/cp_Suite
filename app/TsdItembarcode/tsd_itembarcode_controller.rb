require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TsdItembarcodeController < Rho::RhoController
  include BrowserHelper

  # GET /TsdItembarcode
  def index
    @tsditembarcodes = TsdItembarcode.find(:all)
    render :back => '/app'
  end

  # GET /TsdItembarcode/{1}
  def show
    @tsditembarcode = TsdItembarcode.find(@params['id'])
    if @tsditembarcode
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /TsdItembarcode/new
  def new
    @tsditembarcode = TsdItembarcode.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /TsdItembarcode/{1}/edit
  def edit
    @tsditembarcode = TsdItembarcode.find(@params['id'])
    if @tsditembarcode
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /TsdItembarcode/create
  def create
    @tsditembarcode = TsdItembarcode.create(@params['tsditembarcode'])
    redirect :action => :index
  end

  # POST /TsdItembarcode/{1}/update
  def update
    @tsditembarcode = TsdItembarcode.find(@params['id'])
    @tsditembarcode.update_attributes(@params['tsditembarcode']) if @tsditembarcode
    redirect :action => :index
  end

  # POST /TsdItembarcode/{1}/delete
  def delete
    @tsditembarcode = TsdItembarcode.find(@params['id'])
    @tsditembarcode.destroy if @tsditembarcode
    redirect :action => :index  
  end
end

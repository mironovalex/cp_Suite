require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TsdInventsumtmpController < Rho::RhoController
  include BrowserHelper

  # GET /TsdInventsumtmp
  def index
    @tsdinventsumtmps = TsdInventsumtmp.find(:all)
    render :back => '/app'
  end

  # GET /TsdInventsumtmp/{1}
  def show
    @tsdinventsumtmp = TsdInventsumtmp.find(@params['id'])
    if @tsdinventsumtmp
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /TsdInventsumtmp/new
  def new
    @tsdinventsumtmp = TsdInventsumtmp.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /TsdInventsumtmp/{1}/edit
  def edit
    @tsdinventsumtmp = TsdInventsumtmp.find(@params['id'])
    if @tsdinventsumtmp
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /TsdInventsumtmp/create
  def create
    @tsdinventsumtmp = TsdInventsumtmp.create(@params['tsdinventsumtmp'])
    redirect :action => :index
  end

  # POST /TsdInventsumtmp/{1}/update
  def update
    @tsdinventsumtmp = TsdInventsumtmp.find(@params['id'])
    @tsdinventsumtmp.update_attributes(@params['tsdinventsumtmp']) if @tsdinventsumtmp
    redirect :action => :index
  end

  # POST /TsdInventsumtmp/{1}/delete
  def delete
    @tsdinventsumtmp = TsdInventsumtmp.find(@params['id'])
    @tsdinventsumtmp.destroy if @tsdinventsumtmp
    redirect :action => :index  
  end
end

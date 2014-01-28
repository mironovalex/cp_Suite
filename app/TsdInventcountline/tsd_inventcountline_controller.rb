require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TsdInventcountlineController < Rho::RhoController
  include BrowserHelper

  # GET /TsdInventcountline
  def index
    @tsd_inventcountlines = TsdInventcountline.find(:all)
    render :back => '/app'
  end

  # GET /TsdInventcountline/{1}
  def show
    @tsd_inventcountline = TsdInventcountline.find(@params['id'])
    if @tsd_inventcountline
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /TsdInventcountline/new
  def new
    @tsd_inventcountline = TsdInventcountline.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /TsdInventcountline/{1}/edit
  def edit
    @tsd_inventcountline = TsdInventcountline.find(@params['id'])
    if @tsd_inventcountline
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /TsdInventcountline/create
  def create
    @tsd_inventcountline = TsdInventcountline.create(@params['tsd_inventcountline'])
    redirect :action => :index
  end

  # POST /TsdInventcountline/{1}/update
  def update
    @tsd_inventcountline = TsdInventcountline.find(@params['id'])
    @tsd_inventcountline.update_attributes(@params['tsd_inventcountline']) if @tsd_inventcountline
    redirect :action => :index
  end

  # POST /TsdInventcountline/{1}/delete
  def delete
    @tsd_inventcountline = TsdInventcountline.find(@params['id'])
    @tsd_inventcountline.destroy if @tsd_inventcountline
    redirect :action => :index  
  end
end

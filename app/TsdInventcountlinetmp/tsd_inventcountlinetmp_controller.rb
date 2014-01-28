require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TsdInventcountlinetmpController < Rho::RhoController
  include BrowserHelper

  # GET /TsdInventcountlinetmp
  def index
    @tsd_inventcountlinetmps = TsdInventcountlinetmp.find(:all)
    render :back => '/app'
  end

  # GET /TsdInventcountlinetmp/{1}
  def show
    @tsd_inventcountlinetmp = TsdInventcountlinetmp.find(@params['id'])
    if @tsd_inventcountlinetmp
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /TsdInventcountlinetmp/new
  def new
    @tsd_inventcountlinetmp = TsdInventcountlinetmp.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /TsdInventcountlinetmp/{1}/edit
  def edit
    @tsd_inventcountlinetmp = TsdInventcountlinetmp.find(@params['id'])
    if @tsd_inventcountlinetmp
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /TsdInventcountlinetmp/create
  def create
    @tsd_inventcountlinetmp = TsdInventcountlinetmp.create(@params['tsd_inventcountlinetmp'])
    redirect :action => :index
  end

  # POST /TsdInventcountlinetmp/{1}/update
  def update
    @tsd_inventcountlinetmp = TsdInventcountlinetmp.find(@params['id'])
    @tsd_inventcountlinetmp.update_attributes(@params['tsd_inventcountlinetmp']) if @tsd_inventcountlinetmp
    redirect :action => :index
  end

  # POST /TsdInventcountlinetmp/{1}/delete
  def delete
    @tsd_inventcountlinetmp = TsdInventcountlinetmp.find(@params['id'])
    @tsd_inventcountlinetmp.destroy if @tsd_inventcountlinetmp
    redirect :action => :index  
  end
end

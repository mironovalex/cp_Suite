require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TsdInventlocationController < Rho::RhoController
  include BrowserHelper

  # GET /TsdInventlocation
  def index
    @tsd_inventlocations = TsdInventlocation.find(:all)
    render :back => '/app'
  end

  # GET /TsdInventlocation/{1}
  def show
    @tsd_inventlocation = TsdInventlocation.find(@params['id'])
    if @tsd_inventlocation
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /TsdInventlocation/new
  def new
    @tsd_inventlocation = TsdInventlocation.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /TsdInventlocation/{1}/edit
  def edit
    @tsd_inventlocation = TsdInventlocation.find(@params['id'])
    if @tsd_inventlocation
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /TsdInventlocation/create
  def create
    @tsd_inventlocation = TsdInventlocation.create(@params['tsd_inventlocation'])
    redirect :action => :index
  end

  # POST /TsdInventlocation/{1}/update
  def update
    @tsd_inventlocation = TsdInventlocation.find(@params['id'])
    @tsd_inventlocation.update_attributes(@params['tsd_inventlocation']) if @tsd_inventlocation
    redirect :action => :index
  end

  # POST /TsdInventlocation/{1}/delete
  def delete
    @tsd_inventlocation = TsdInventlocation.find(@params['id'])
    @tsd_inventlocation.destroy if @tsd_inventlocation
    redirect :action => :index  
  end
end

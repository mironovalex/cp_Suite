require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TsdInventcountjourController < Rho::RhoController
  include BrowserHelper

  # GET /TsdInventcountjour
  def index
    @tsd_inventcountjours = TsdInventcountjour.find(:all)
    render :back => '/app'
  end

  # GET /TsdInventcountjour/{1}
  def show
    @tsd_inventcountjour = TsdInventcountjour.find(@params['id'])
    if @tsd_inventcountjour
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /TsdInventcountjour/new
  def new
    @tsd_inventcountjour = TsdInventcountjour.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /TsdInventcountjour/{1}/edit
  def edit
    @tsd_inventcountjour = TsdInventcountjour.find(@params['id'])
    if @tsd_inventcountjour
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /TsdInventcountjour/create
  def create
    @tsd_inventcountjour = TsdInventcountjour.create(@params['tsd_inventcountjour'])
    redirect :action => :index
  end

  # POST /TsdInventcountjour/{1}/update
  def update
    @tsd_inventcountjour = TsdInventcountjour.find(@params['id'])
    @tsd_inventcountjour.update_attributes(@params['tsd_inventcountjour']) if @tsd_inventcountjour
    redirect :action => :index
  end

  # POST /TsdInventcountjour/{1}/delete
  def delete
    @tsd_inventcountjour = TsdInventcountjour.find(@params['id'])
    @tsd_inventcountjour.destroy if @tsd_inventcountjour
    redirect :action => :index  
  end
end

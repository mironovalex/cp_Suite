require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TsdInventpriceController < Rho::RhoController
  include BrowserHelper

  # GET /TsdInventprice
  def index
    @tsd_inventprices = TsdInventprice.find(:all)
    render :back => '/app'
  end

  # GET /TsdInventprice/{1}
  def show
    @tsd_inventprice = TsdInventprice.find(@params['id'])
    if @tsd_inventprice
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /TsdInventprice/new
  def new
    @tsd_inventprice = TsdInventprice.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /TsdInventprice/{1}/edit
  def edit
    @tsd_inventprice = TsdInventprice.find(@params['id'])
    if @tsd_inventprice
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /TsdInventprice/create
  def create
    @tsd_inventprice = TsdInventprice.create(@params['tsd_inventprice'])
    redirect :action => :index
  end

  # POST /TsdInventprice/{1}/update
  def update
    @tsd_inventprice = TsdInventprice.find(@params['id'])
    @tsd_inventprice.update_attributes(@params['tsd_inventprice']) if @tsd_inventprice
    redirect :action => :index
  end

  # POST /TsdInventprice/{1}/delete
  def delete
    @tsd_inventprice = TsdInventprice.find(@params['id'])
    @tsd_inventprice.destroy if @tsd_inventprice
    redirect :action => :index  
  end
end

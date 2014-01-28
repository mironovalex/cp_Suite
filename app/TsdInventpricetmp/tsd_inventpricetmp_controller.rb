require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TsdInventpricetmpController < Rho::RhoController
  include BrowserHelper

  # GET /TsdInventpricetmp
  def index
    @tsdinventpricetmps = TsdInventpricetmp.find(:all)
    render :back => '/app'
  end

  # GET /TsdInventpricetmp/{1}
  def show
    @tsdinventpricetmp = TsdInventpricetmp.find(@params['id'])
    if @tsdinventpricetmp
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /TsdInventpricetmp/new
  def new
    @tsdinventpricetmp = TsdInventpricetmp.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /TsdInventpricetmp/{1}/edit
  def edit
    @tsdinventpricetmp = TsdInventpricetmp.find(@params['id'])
    if @tsdinventpricetmp
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /TsdInventpricetmp/create
  def create
    @tsdinventpricetmp = TsdInventpricetmp.create(@params['tsdinventpricetmp'])
    redirect :action => :index
  end

  # POST /TsdInventpricetmp/{1}/update
  def update
    @tsdinventpricetmp = TsdInventpricetmp.find(@params['id'])
    @tsdinventpricetmp.update_attributes(@params['tsdinventpricetmp']) if @tsdinventpricetmp
    redirect :action => :index
  end

  # POST /TsdInventpricetmp/{1}/delete
  def delete
    @tsdinventpricetmp = TsdInventpricetmp.find(@params['id'])
    @tsdinventpricetmp.destroy if @tsdinventpricetmp
    redirect :action => :index  
  end
end

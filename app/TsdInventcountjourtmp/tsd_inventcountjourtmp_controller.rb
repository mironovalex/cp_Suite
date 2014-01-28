require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TsdInventcountjourtmpController < Rho::RhoController
  include BrowserHelper

  # GET /TsdInventcountjourtmp
  def index
    @tsd_inventcountjourtmps = TsdInventcountjourtmp.find(:all)
    render :back => '/app'
  end

  # GET /TsdInventcountjourtmp/{1}
  def show
    @tsd_inventcountjourtmp = TsdInventcountjourtmp.find(@params['id'])
    if @tsd_inventcountjourtmp
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /TsdInventcountjourtmp/new
  def new
    @tsd_inventcountjourtmp = TsdInventcountjourtmp.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /TsdInventcountjourtmp/{1}/edit
  def edit
    @tsd_inventcountjourtmp = TsdInventcountjourtmp.find(@params['id'])
    if @tsd_inventcountjourtmp
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /TsdInventcountjourtmp/create
  def create
    @tsd_inventcountjourtmp = TsdInventcountjourtmp.create(@params['tsd_inventcountjourtmp'])
    redirect :action => :index
  end

  # POST /TsdInventcountjourtmp/{1}/update
  def update
    @tsd_inventcountjourtmp = TsdInventcountjourtmp.find(@params['id'])
    @tsd_inventcountjourtmp.update_attributes(@params['tsd_inventcountjourtmp']) if @tsd_inventcountjourtmp
    redirect :action => :index
  end

  # POST /TsdInventcountjourtmp/{1}/delete
  def delete
    @tsd_inventcountjourtmp = TsdInventcountjourtmp.find(@params['id'])
    @tsd_inventcountjourtmp.destroy if @tsd_inventcountjourtmp
    redirect :action => :index  
  end
end

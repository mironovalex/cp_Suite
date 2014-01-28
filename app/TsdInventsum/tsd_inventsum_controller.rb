require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TsdInventsumController < Rho::RhoController
  include BrowserHelper

  # GET /TsdInventsum
  def index
    @tsd_inventsums = TsdInventsum.find(:all)
    render :back => '/app'
  end

  # GET /TsdInventsum/{1}
  def show
    @tsd_inventsum = TsdInventsum.find(@params['id'])
    if @tsd_inventsum
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /TsdInventsum/new
  def new
    @tsd_inventsum = TsdInventsum.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /TsdInventsum/{1}/edit
  def edit
    @tsd_inventsum = TsdInventsum.find(@params['id'])
    if @tsd_inventsum
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /TsdInventsum/create
  def create
    @tsd_inventsum = TsdInventsum.create(@params['tsd_inventsum'])
    redirect :action => :index
  end

  # POST /TsdInventsum/{1}/update
  def update
    @tsd_inventsum = TsdInventsum.find(@params['id'])
    @tsd_inventsum.update_attributes(@params['tsd_inventsum']) if @tsd_inventsum
    redirect :action => :index
  end

  # POST /TsdInventsum/{1}/delete
  def delete
    @tsd_inventsum = TsdInventsum.find(@params['id'])
    @tsd_inventsum.destroy if @tsd_inventsum
    redirect :action => :index  
  end
end

require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TsdInventtableController < Rho::RhoController
  include BrowserHelper

  # GET /TsdInventtable
  def index
    @tsd_inventtables = TsdInventtable.find(:all)
    render :back => '/app'
  end

  # GET /TsdInventtable/{1}
  def show
    @tsd_inventtable = TsdInventtable.find(@params['id'])
    if @tsd_inventtable
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /TsdInventtable/new
  def new
    @tsd_inventtable = TsdInventtable.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /TsdInventtable/{1}/edit
  def edit
    @tsd_inventtable = TsdInventtable.find(@params['id'])
    if @tsd_inventtable
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /TsdInventtable/create
  def create
    @tsd_inventtable = TsdInventtable.create(@params['tsd_inventtable'])
    redirect :action => :index
  end

  # POST /TsdInventtable/{1}/update
  def update
    @tsd_inventtable = TsdInventtable.find(@params['id'])
    @tsd_inventtable.update_attributes(@params['tsd_inventtable']) if @tsd_inventtable
    redirect :action => :index
  end

  # POST /TsdInventtable/{1}/delete
  def delete
    @tsd_inventtable = TsdInventtable.find(@params['id'])
    @tsd_inventtable.destroy if @tsd_inventtable
    redirect :action => :index  
  end
end

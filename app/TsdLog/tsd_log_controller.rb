require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TsdLogController < Rho::RhoController
  include BrowserHelper

  # GET /TsdLog
  def index
    @tsd_logs = TsdLog.find(:all)
    render :back => '/app'
  end

  # GET /TsdLog/{1}
  def show
    @tsd_log = TsdLog.find(@params['id'])
    if @tsd_log
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /TsdLog/new
  def new
    @tsd_log = TsdLog.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /TsdLog/{1}/edit
  def edit
    @tsd_log = TsdLog.find(@params['id'])
    if @tsd_log
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /TsdLog/create
  def create
    @tsd_log = TsdLog.create(@params['tsd_log'])
    redirect :action => :index
  end

  # POST /TsdLog/{1}/update
  def update
    @tsd_log = TsdLog.find(@params['id'])
    @tsd_log.update_attributes(@params['tsd_log']) if @tsd_log
    redirect :action => :index
  end

  # POST /TsdLog/{1}/delete
  def delete
    @tsd_log = TsdLog.find(@params['id'])
    @tsd_log.destroy if @tsd_log
    redirect :action => :index  
  end
end

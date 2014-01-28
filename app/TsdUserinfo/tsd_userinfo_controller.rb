require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TsdUserinfoController < Rho::RhoController
  include BrowserHelper

  # GET /TsdUserinfo
  def index
    @tsd_userinfos = TsdUserinfo.find(:all)
    render :back => '/app'
  end

  # GET /TsdUserinfo/{1}
  def show
    @tsd_userinfo = TsdUserinfo.find(@params['id'])
    if @tsd_userinfo
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /TsdUserinfo/new
  def new
    @tsd_userinfo = TsdUserinfo.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /TsdUserinfo/{1}/edit
  def edit
    @tsd_userinfo = TsdUserinfo.find(@params['id'])
    if @tsd_userinfo
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /TsdUserinfo/create
  def create
    @tsd_userinfo = TsdUserinfo.create(@params['tsd_userinfo'])
    redirect :action => :index
  end

  # POST /TsdUserinfo/{1}/update
  def update
    @tsd_userinfo = TsdUserinfo.find(@params['id'])
    @tsd_userinfo.update_attributes(@params['tsd_userinfo']) if @tsd_userinfo
    redirect :action => :index
  end

  # POST /TsdUserinfo/{1}/delete
  def delete
    @tsd_userinfo = TsdUserinfo.find(@params['id'])
    @tsd_userinfo.destroy if @tsd_userinfo
    redirect :action => :index  
  end
end

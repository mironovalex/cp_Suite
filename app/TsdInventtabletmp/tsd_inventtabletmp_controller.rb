require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TsdInventtabletmpController < Rho::RhoController
  include BrowserHelper

  # GET /TsdInventtabletmp
  def index
    @tsdinventtabletmps = TsdInventtabletmp.find(:all)
    render :back => '/app'
  end

  # GET /TsdInventtabletmp/{1}
  def show
    @tsdinventtabletmp = TsdInventtabletmp.find(@params['id'])
    if @tsdinventtabletmp
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /TsdInventtabletmp/new
  def new
    @tsdinventtabletmp = TsdInventtabletmp.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /TsdInventtabletmp/{1}/edit
  def edit
    @tsdinventtabletmp = TsdInventtabletmp.find(@params['id'])
    if @tsdinventtabletmp
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /TsdInventtabletmp/create
  def create
    @tsdinventtabletmp = TsdInventtabletmp.create(@params['tsdinventtabletmp'])
    redirect :action => :index
  end

  # POST /TsdInventtabletmp/{1}/update
  def update
    @tsdinventtabletmp = TsdInventtabletmp.find(@params['id'])
    @tsdinventtabletmp.update_attributes(@params['tsdinventtabletmp']) if @tsdinventtabletmp
    redirect :action => :index
  end

  # POST /TsdInventtabletmp/{1}/delete
  def delete
    @tsdinventtabletmp = TsdInventtabletmp.find(@params['id'])
    @tsdinventtabletmp.destroy if @tsdinventtabletmp
    redirect :action => :index  
  end
end

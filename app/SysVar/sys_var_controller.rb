require 'rho/rhocontroller'
require 'helpers/browser_helper'

class SysVarController < Rho::RhoController
  include BrowserHelper

  # GET /SysVar
  def index
    @sys_vars = SysVar.find(:all)
    render :back => '/app'
  end

  # GET /SysVar/{1}
  def show
    @sys_var = SysVar.find(@params['id'])
    if @sys_var
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /SysVar/new
  def new
    @sys_var = SysVar.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /SysVar/{1}/edit
  def edit
    @sys_var = SysVar.find(@params['id'])
    if @sys_var
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /SysVar/create
  def create
    @sys_var = SysVar.create(@params['sys_var'])
    redirect :action => :index
  end

  # POST /SysVar/{1}/update
  def update
    @sys_var = SysVar.find(@params['id'])
    @sys_var.update_attributes(@params['sys_var']) if @sys_var
    redirect :action => :index
  end

  # POST /SysVar/{1}/delete
  def delete
    @sys_var = SysVar.find(@params['id'])
    @sys_var.destroy if @sys_var
    redirect :action => :index  
  end
end

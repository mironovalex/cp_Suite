require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TMPController < Rho::RhoController
  include BrowserHelper

  # GET /TMP
  def index
    @tmps = TMP.find(:all)
    render :back => '/app'
  end

  # GET /TMP/{1}
  def show
    @tmp = TMP.find(@params['id'])
    if @tmp
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /TMP/new
  def new
    @tmp = TMP.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /TMP/{1}/edit
  def edit
    @tmp = TMP.find(@params['id'])
    if @tmp
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /TMP/create
  def create
    @tmp = TMP.create(@params['tmp'])
    redirect :action => :index
  end

  # POST /TMP/{1}/update
  def update
    @tmp = TMP.find(@params['id'])
    @tmp.update_attributes(@params['tmp']) if @tmp
    redirect :action => :index
  end

  # POST /TMP/{1}/delete
  def delete
    @tmp = TMP.find(@params['id'])
    @tmp.destroy if @tmp
    redirect :action => :index  
  end
end

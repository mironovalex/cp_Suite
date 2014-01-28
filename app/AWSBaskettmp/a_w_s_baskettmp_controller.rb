require 'rho/rhocontroller'
require 'helpers/browser_helper'

class AWSBaskettmpController < Rho::RhoController
  include BrowserHelper

  # GET /AWSBaskettmp
  def index
    @awsbaskettmps = AWSBaskettmp.find(:all)
    render :back => '/app'
  end

  # GET /AWSBaskettmp/{1}
  def show
    @awsbaskettmp = AWSBaskettmp.find(@params['id'])
    if @awsbaskettmp
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /AWSBaskettmp/new
  def new
    @awsbaskettmp = AWSBaskettmp.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /AWSBaskettmp/{1}/edit
  def edit
    @awsbaskettmp = AWSBaskettmp.find(@params['id'])
    if @awsbaskettmp
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /AWSBaskettmp/create
  def create
    @awsbaskettmp = AWSBaskettmp.create(@params['awsbaskettmp'])
    redirect :action => :index
  end

  # POST /AWSBaskettmp/{1}/update
  def update
    @awsbaskettmp = AWSBaskettmp.find(@params['id'])
    @awsbaskettmp.update_attributes(@params['awsbaskettmp']) if @awsbaskettmp
    redirect :action => :index
  end

  # POST /AWSBaskettmp/{1}/delete
  def delete
    @awsbaskettmp = AWSBaskettmp.find(@params['id'])
    @awsbaskettmp.destroy if @awsbaskettmp
    redirect :action => :index  
  end
end

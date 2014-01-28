require 'rho/rhocontroller'
require 'helpers/browser_helper'

class AWSBasketController < Rho::RhoController
  include BrowserHelper

  # GET /AWSBasket
  def index
    @awsbaskets = AWSBasket.find(:all)
    render :back => '/app'
  end

  # GET /AWSBasket/{1}
  def show
    @awsbasket = AWSBasket.find(@params['id'])
    if @awsbasket
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /AWSBasket/new
  def new
    @awsbasket = AWSBasket.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /AWSBasket/{1}/edit
  def edit
    @awsbasket = AWSBasket.find(@params['id'])
    if @awsbasket
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /AWSBasket/create
  def create
    @awsbasket = AWSBasket.create(@params['awsbasket'])
    redirect :action => :index
  end

  # POST /AWSBasket/{1}/update
  def update
    @awsbasket = AWSBasket.find(@params['id'])
    @awsbasket.update_attributes(@params['awsbasket']) if @awsbasket
    redirect :action => :index
  end

  # POST /AWSBasket/{1}/delete
  def delete
    @awsbasket = AWSBasket.find(@params['id'])
    @awsbasket.destroy if @awsbasket
    redirect :action => :index  
  end
end

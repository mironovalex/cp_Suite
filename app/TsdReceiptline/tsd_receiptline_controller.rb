require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TsdReceiptlineController < Rho::RhoController
  include BrowserHelper

  # GET /TsdReceiptline
  def index
    @tsd_receiptlines = TsdReceiptline.find(:all)
    render :back => '/app'
  end

  # GET /TsdReceiptline/{1}
  def show
    @tsd_receiptline = TsdReceiptline.find(@params['id'])
    if @tsd_receiptline
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /TsdReceiptline/new
  def new
    @tsd_receiptline = TsdReceiptline.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /TsdReceiptline/{1}/edit
  def edit
    @tsd_receiptline = TsdReceiptline.find(@params['id'])
    if @tsd_receiptline
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /TsdReceiptline/create
  def create
    @tsd_receiptline = TsdReceiptline.create(@params['tsd_receiptline'])
    redirect :action => :index
  end

  # POST /TsdReceiptline/{1}/update
  def update
    @tsd_receiptline = TsdReceiptline.find(@params['id'])
    @tsd_receiptline.update_attributes(@params['tsd_receiptline']) if @tsd_receiptline
    redirect :action => :index
  end

  # POST /TsdReceiptline/{1}/delete
  def delete
    @tsd_receiptline = TsdReceiptline.find(@params['id'])
    @tsd_receiptline.destroy if @tsd_receiptline
    redirect :action => :index  
  end
end

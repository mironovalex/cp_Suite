require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TsdReceiptjourtmpController < Rho::RhoController
  include BrowserHelper

  # GET /TsdReceiptjourtmp
  def index
    @tsd_receiptjourtmps = TsdReceiptjourtmp.find(:all)
    render :back => '/app'
  end

  # GET /TsdReceiptjourtmp/{1}
  def show
    @tsd_receiptjourtmp = TsdReceiptjourtmp.find(@params['id'])
    if @tsd_receiptjourtmp
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /TsdReceiptjourtmp/new
  def new
    @tsd_receiptjourtmp = TsdReceiptjourtmp.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /TsdReceiptjourtmp/{1}/edit
  def edit
    @tsd_receiptjourtmp = TsdReceiptjourtmp.find(@params['id'])
    if @tsd_receiptjourtmp
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /TsdReceiptjourtmp/create
  def create
    @tsd_receiptjourtmp = TsdReceiptjourtmp.create(@params['tsd_receiptjourtmp'])
    redirect :action => :index
  end

  # POST /TsdReceiptjourtmp/{1}/update
  def update
    @tsd_receiptjourtmp = TsdReceiptjourtmp.find(@params['id'])
    @tsd_receiptjourtmp.update_attributes(@params['tsd_receiptjourtmp']) if @tsd_receiptjourtmp
    redirect :action => :index
  end

  # POST /TsdReceiptjourtmp/{1}/delete
  def delete
    @tsd_receiptjourtmp = TsdReceiptjourtmp.find(@params['id'])
    @tsd_receiptjourtmp.destroy if @tsd_receiptjourtmp
    redirect :action => :index  
  end
end

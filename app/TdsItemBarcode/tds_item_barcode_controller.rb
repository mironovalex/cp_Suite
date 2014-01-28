require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TdsItemBarcodeController < Rho::RhoController
  include BrowserHelper

  # GET /TdsItemBarcode
  def index
    @tdsitembarcodes = TdsItemBarcode.find(:all)
    render :back => '/app'
  end

  # GET /TdsItemBarcode/{1}
  def show
    @tdsitembarcode = TdsItemBarcode.find(@params['id'])
    if @tdsitembarcode
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /TdsItemBarcode/new
  def new
    @tdsitembarcode = TdsItemBarcode.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /TdsItemBarcode/{1}/edit
  def edit
    @tdsitembarcode = TdsItemBarcode.find(@params['id'])
    if @tdsitembarcode
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /TdsItemBarcode/create
  def create
    @tdsitembarcode = TdsItemBarcode.create(@params['tdsitembarcode'])
    redirect :action => :index
  end

  # POST /TdsItemBarcode/{1}/update
  def update
    @tdsitembarcode = TdsItemBarcode.find(@params['id'])
    @tdsitembarcode.update_attributes(@params['tdsitembarcode']) if @tdsitembarcode
    redirect :action => :index
  end

  # POST /TdsItemBarcode/{1}/delete
  def delete
    @tdsitembarcode = TdsItemBarcode.find(@params['id'])
    @tdsitembarcode.destroy if @tdsitembarcode
    redirect :action => :index  
  end
end

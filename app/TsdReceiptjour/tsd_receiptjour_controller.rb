require 'rho/rhocontroller'
require 'helpers/browser_helper'

class TsdReceiptjourController < Rho::RhoController
  include BrowserHelper

  # GET /TsdReceiptjour
  def index
    @tsd_receiptjours = TsdReceiptjour.find(:all)
    render :back => '/app'
  end

  # GET /TsdReceiptjour/{1}
  def show
    @tsd_receiptjour = TsdReceiptjour.find(@params['id'])
    if @tsd_receiptjour
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /TsdReceiptjour/new
  def new
    @tsd_receiptjour = TsdReceiptjour.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /TsdReceiptjour/{1}/edit
  def edit
    @tsd_receiptjour = TsdReceiptjour.find(@params['id'])
    if @tsd_receiptjour
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /TsdReceiptjour/create
  def create
    @tsd_receiptjour = TsdReceiptjour.create(@params['tsd_receiptjour'])
    redirect :action => :index
  end

  # POST /TsdReceiptjour/{1}/update
  def update
    @tsd_receiptjour = TsdReceiptjour.find(@params['id'])
    @tsd_receiptjour.update_attributes(@params['tsd_receiptjour']) if @tsd_receiptjour
    redirect :action => :index
  end

  # POST /TsdReceiptjour/{1}/delete
  def delete
    @tsd_receiptjour = TsdReceiptjour.find(@params['id'])
    @tsd_receiptjour.destroy if @tsd_receiptjour
    redirect :action => :index  
  end
end

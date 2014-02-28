require 'rho'
require 'rho/rhocontroller'
require 'rho/rhoerror'
require 'helpers/browser_helper'

class SettingsController < Rho::RhoController
  include BrowserHelper
  
  def exit
    SyncEngine.logout
    
    System.exit;
  end
  
  def index
    @msg = @params['msg']
    render
  end

  def login
    @msg = @params['msg']
    render :action => :login
  end

  def login_callback
    errCode = @params['error_code'].to_i
    if errCode == 0
      # run sync if we were successful
      WebView.navigate Rho::RhoConfig.options_path
      SyncEngine.dosync
    else
      if errCode == Rho::RhoError::ERR_CUSTOMSYNCSERVER
        @msg = @params['error_message']
      end
        
      if !@msg || @msg.length == 0   
        @msg = Rho::RhoError.new(errCode).message
      end
      
      WebView.navigate ( url_for :action => :login, :query => {:msg => @msg} )
    end  
  end

  def do_login
    if @params['login'] and @params['password']
      begin
        SyncEngine.login(@params['login'], @params['password'], (url_for :action => :login_callback) )
        @response['headers']['Wait-Page'] = 'true'
        render :action => :wait
      rescue Rho::RhoError => e
        @msg = e.message
        render :action => :login
      end
    else
      @msg = Rho::RhoError.err_message(Rho::RhoError::ERR_UNATHORIZED) unless @msg && @msg.length > 0
      render :action => :login
    end
  end
  
  def logout
    SyncEngine.logout
    @msg = "You have been logged out."
    render :action => :login
  end
  
  def reset
    render :action => :reset
  end
  
  def do_reset
    Rhom::Rhom.database_full_reset
    SyncEngine.dosync
    @msg = "Database has been reset."
    redirect :action => :index, :query => {:msg => @msg}
  end
  
  def do_sync
    dnload_from_file
    
#    SyncEngine.dosync
#    @msg =  "Sync has been triggered."
#    redirect :action => :index, :query => {:msg => @msg}
  end  
  
  def wait
    ##WebView.execute_js("sync_msg('" + $sync_msg.to_s + "');")  
  end
  
  def sync_notify
    #WebView.execute_js("sync_msg('" + $sync_msg.to_s + "');")   
    
#    if @params['error_message'].downcase == 'unknown client'
#      puts "Received unknown client, resetting!"
#      Rhom::Rhom.database_fullclient_reset_and_logout
#    end
    
    $sync_status = "0"
    
#    Alert.show_popup(
#        :message=>  @params['status'] + "|" + $sync_control.to_s,
#        :title=>"Ошибка",
#        :buttons => ["Ok"]
#     )          
	 
     if (@params['status'] == "ok")
       $sync_status = "1"
     end
     
    if (@params['status'] == "error")
      $sync_status = "1"
      $msg = "Ошибка синхронизации!"
    end
         
#    if ( $sync_status != "1")
#      Alert.show_popup(
#          :message=>  @params['status'] + "|" + $sync_control.to_s,
#          :title=>"Ошибка",
#          :buttons => ["Ok"]
#       )  
#    end  
      
    if ( $sync_status == "1")
	    if ($sync_control == "0") 
        if (@params['status'] == "ok")
          TsdLog.delete_all()
        end
			WebView.navigate( url_for :controller => :Auto, :action => :inp_location_2)
		end
	
	    if ($sync_control == "1") 
			WebView.navigate( url_for :controller => :Auto, :action => :inp_location_3)
		end

		if ($sync_control == "2") 
			WebView.navigate( url_for :controller => :Auto, :action => :inp_location)
		end

		
		if ($sync_control == "3") 
			WebView.navigate( url_for :controller => :MainMenu, :action => :load_Items_2)
		end
		
		if ($sync_control == "4") 
			WebView.navigate( url_for :controller => :MainMenu, :action => :load_Items_3)
		end

		if ($sync_control == "5") 
			WebView.navigate( url_for :controller => :MainMenu, :action => :load_Items_4)
		end
		
     if ($sync_control == "60") 
       WebView.navigate( url_for :controller => :MainMenu, :action => :load_Items_5)
     end		
		
		if ($sync_control == "6") 
		  if ($Menu_mode == "1")
			WebView.navigate( url_for :controller => :ChkItem, :action => :ItemChkInp)
		  end	

		  if ($Menu_mode == "2")
			WebView.navigate( url_for :controller => :Basket, :action => :show_main_nenu_basket)
		  end

		  if ($Menu_mode == "3")
			WebView.navigate( url_for :controller => :Receipt, :action => :shk_date)
		  end
		  
		  if ($Menu_mode == "4")
			WebView.navigate( url_for :controller => :Invent, :action => :shk_date )
		  end		  		  
		end

		if ($sync_control == "7") 
			WebView.navigate( url_for :controller => :Basket, :action => :basket_upload_2)
		end

		if ($sync_control == "8") 
			WebView.navigate( url_for :controller => :Basket, :action => :basket_upload_3)
      $sync_msg = "" 
		end
		
		
		
		
		if ($sync_control == "9") 
			WebView.navigate( url_for :controller => :Receipt, :action => :dnload_receipt_2)
		end
    
		if ($sync_control == "10")
			WebView.navigate( url_for :controller => :Receipt, :action => :dnload_receipt_3)
      $sync_msg = "" 
		end  

		
		
		if ($sync_control == "11")
			WebView.navigate( url_for :controller => :Receipt, :action => :upload_receipt_2)		
		end 
		
		if ($sync_control == "12")
			WebView.navigate( url_for :controller => :Receipt, :action => :upload_receipt_3)	
		end		

		if ($sync_control == "13")
			WebView.navigate( url_for :controller => :Receipt, :action => :upload_receipt_4)		
		end	

		if ($sync_control == "14")
			WebView.navigate( url_for :controller => :Receipt, :action => :upload_receipt_5)	
      $sync_msg = "" 	
		end			
		

		

		if ($sync_control == "15") 
			WebView.navigate( url_for :controller => :Invent, :action => :dnload_invent_2)
		end
    
		if ($sync_control == "16")
			WebView.navigate( url_for :controller => :Invent, :action => :dnload_invent_3)
      $sync_msg = "" 
		end  

		
		
		if ($sync_control == "17")
			WebView.navigate( url_for :controller => :Invent, :action => :upload_invent_2)		
		end 
		
		if ($sync_control == "18")
			WebView.navigate( url_for :controller => :Invent, :action => :upload_invent_3)	
		end		

		if ($sync_control == "19")
			WebView.navigate( url_for :controller => :Invent, :action => :upload_invent_4)		
		end	

		if ($sync_control == "20")
			WebView.navigate( url_for :controller => :Invent, :action => :upload_invent_5)	
      $sync_msg = "" 	
		end			
			
		
		
      if ($sync_control == "30") 
        WebView.navigate( url_for :controller => :Receipt, :action => :load_Items_2)
      end
      
      if ($sync_control == "40") 
        WebView.navigate( url_for :controller => :Receipt, :action => :load_Items_3)
      end
  
      if ($sync_control == "50") 
        WebView.navigate( url_for :controller => :Receipt, :action => :load_Items_4)
      end
      
       if ($sync_control == "600") 
         WebView.navigate( url_for :controller => :Receipt, :action => :load_Items_5)
       end    
		
       
       
      if ($sync_control == "31") 
        WebView.navigate( url_for :controller => :Invent, :action => :load_Items_2)
      end
      
      if ($sync_control == "41") 
        WebView.navigate( url_for :controller => :Invent, :action => :load_Items_3)
      end
  
      if ($sync_control == "51") 
        WebView.navigate( url_for :controller => :Invent, :action => :load_Items_4)
      end
      
       if ($sync_control == "601") 
         WebView.navigate( url_for :controller => :Invent, :action => :load_Items_5)
       end  		
			
    end     
      
#    if @params['error_message'].downcase == 'unknown client'
#      puts "Received unknown client, resetting!"
#      Rhom::Rhom.database_fullclient_reset_and_logout
#    end 
     
  	status = @params['status'] ? @params['status'] : ""
  	
  	# un-comment to show a debug status pop-up
  	#Alert.show_status( "Status", "#{@params['source_name']} : #{status}", Rho::RhoMessages.get_message('hide'))
  	
  	if status == "in_progress" 	
  	  # do nothing
  	elsif status == "complete"
      $sync_status = "1"
      $sync_err = "0"
      $sync_err_msg = ""
      #WebView.navigate Rho::RhoConfig.start_path0 if @params['sync_type'] != 'bulk'
  	elsif status == "error"
	
      if @params['server_errors'] && @params['server_errors']['create-error']
        SyncEngine.on_sync_create_error( 
          @params['source_name'], @params['server_errors']['create-error'].keys, :delete )
      end

      if @params['server_errors'] && @params['server_errors']['update-error']
        SyncEngine.on_sync_update_error(
          @params['source_name'], @params['server_errors']['update-error'], :retry )
      end
      
      err_code = @params['error_code'].to_i
      rho_error = Rho::RhoError.new(err_code)
      
      @msg = @params['error_message'] if err_code == Rho::RhoError::ERR_CUSTOMSYNCSERVER
      @msg = rho_error.message unless @msg && @msg.length > 0   

      if rho_error.unknown_client?( @params['error_message'] )
        Rhom::Rhom.database_client_reset
        @msg = "Перезагрузите программу."
#        SyncEngine.dosync               
#      elsif err_code == Rho::RhoError::ERR_UNATHORIZED
#        WebView.navigate( 
#          url_for :action => :login, 
#          :query => {:msg => "Server credentials are expired"} )                
      elsif err_code != Rho::RhoError::ERR_CUSTOMSYNCSERVER
        $sync_status = "1"
#          Alert.show_popup(
#              :message=> "Ошибка синхронизации! " + @msg.to_s + " Попробуйте позже.",
#              :title=>"Ошибка",
#              :buttons => ["Ok"]
#           )  
        $msg = "Ошибка синхронизации! " + @msg.to_s + " Попробуйте позже."  
        WebView.execute_js("sync_msg('" + $msg.to_s + "');")                
        $sync_err = "1" 
        $sync_err_msg = @msg     
        #WebView.navigate( url_for :action => :err_sync, :query => { :msg => @msg } )
      end    
	  end	  
  #end
	  
	  
  end  
  
  def dnload_from_file
      Rhom::Rhom.database_full_reset
    
      # Товары
      fileName_i = File.join(Rho::RhoApplication::get_base_app_path(), '/public/Item.txt')
      lines_i = File.read(fileName_i)
      jsonContent_i = Rho::JSON.parse(lines_i)
      jsonContent_i.each {
      |json|
        Item.create("art" => json['art'], "Item_sh" => json['Item_sh'], "cost" => json['cost'], "name" => json['name'])
      }
      
      # Заказы шапка
      fileName_p = File.join(Rho::RhoApplication::get_base_app_path(), '/public/PoOrder.txt')
      lines_p = File.read(fileName_p)
      jsonContent_p = Rho::JSON.parse(lines_p)
      jsonContent_p.each {
      |json|
        PoOrder.create("num" => json['num'], "count_1" => json['count_1'], "count_2" => json['count_2'])
      }
      
      # Заказы детализация
      fileName_d = File.join(Rho::RhoApplication::get_base_app_path(), '/public/PoDetail.txt')
      lines_d = File.read(fileName_d)
      jsonContent_d = Rho::JSON.parse(lines_d)      
      jsonContent_d.each {
      |json|
        i = 0
        loop do
        i=i.to_i + 1
        PoDetail.create("po_num" => json['po_num'], "item_sh" => json['item_sh'], "count" => json['count'])
        break if i.to_i==1
        end                
       }

      # Инвентаризации шапка
      fileName_ip = File.join(Rho::RhoApplication::get_base_app_path(), '/public/InvOrder.txt')
      lines_ip = File.read(fileName_ip)
      jsonContent_ip = Rho::JSON.parse(lines_ip)
      jsonContent_ip.each {
      |json|
        InvOrder.create("num" => json['num'], "count_1" => json['count_1'], "count_2" => json['count_2'])
      }
    
     # Инвентаризации детализация
     fileName_id = File.join(Rho::RhoApplication::get_base_app_path(), '/public/InvDetail.txt')
     lines_id = File.read(fileName_id)
     jsonContent_id = Rho::JSON.parse(lines_id)
     jsonContent_id.each {
     |json|
       InvDetail.create("inv_num" => json['inv_num'], "item_sh" => json['item_sh'], "count" => json['count'])
      }
                         
    redirect :controller => :Settings, :action => :po_00  
  end
  
  
end

require 'rho/rhocontroller'
require 'helpers/browser_helper'

class MainMenuController < Rho::RhoController
  include BrowserHelper

  def main_menu
    $mstatus = 'CI_IS'
    if !System.get_property('is_emulator')
      Scanner.disable
    end 
  end
  
  def item_sync
    $msg = ""
    $msg1 = ""
    $msg2 = ""
    
    Alert.show_popup(
        :message=> "Справочник товара будет перезаписан, выполнить?",
        :title=>"Внимание",
        :buttons => ["ДА", "HET"],
        :callback => url_for(:action => :on_item_sync)
        ) 
        
    render :action => :main_menu  
  end
  
  def on_item_sync
    if (@params['button_id'] == 'HET')
      render :action => :main_menu
    else
      #redirect :action => :wait
      #redirect :controller => :Settings, :action => :wait
      WebView.navigate( url_for :controller => :Settings, :action => :wait )  
      # Синхронизация со справочниками товаров, цен, остатков и Ш
      $Menu_mode = "5"
     
      load_Items
      #render :action => :main_menu   
    end    
  end
  
  # Отлогин
  def unlogin
    t = Time.now
    
    @TsdUserinfos = TsdUserinfo.find(:first,
             :conditions => { 
             {
             :name => "UserName", 
             :op => "IN" 
             } => $chk_user       
            } )   
    
    # Запись в лог    
    TsdLog.create("UserId" => @TsdUserinfos.UserId, 
                  "InventLocationId" => $chk_loc,
                  "DeviceID" => $device_id,
                  "Date" => t.strftime("%Y-%m-%d"),
                  "Time" => t.strftime("%S").to_i + t.strftime("%M").to_i*60 + t.strftime("%H").to_i*3600,
                  "Operation" => "1",
                  "Status" => "0",                  
                  "Comment" => "")
    
    redirect :controller => :Auto, :action => :sync_one
  end
  
  # Подготовка к выполнению проверки товара
  def chk_item_work
    $status = 'CI_I'
    #Загрузка из просмотра товара
    $basket_load_ftrom_chit = 1
    # Синхронизация со справочниками товаров, цен, остатков и Ш
	  #$Menu_mode = "1"
    #  load_Items
    $msg =""
    $msg1 =""
    $msg2 =""
        
    #redirect :controller => :ChkItem, :action => :ItemChkInp
    redirect :controller => :ChkItem, :action => :CI_UNI
  end

  def load_Items_2 
      redirect :controller => :Settings, :action => :wait
      @TsdItembarcodetmps = TsdItembarcodetemp.find(:first) 
       
      if (@TsdItembarcodetmps)
        $Itembarcode_synccount =  $Itembarcode_synccount.to_i + 5000   
        
        @accts = TsdItembarcode.find_by_sql("INSERT INTO TsdItembarcode( ItemId, InventSizeId, ItemBarCode ) select ItemId, InventSizeId, ItemBarCode from TsdItembarcodetemp")                  
        
        if ($error_status == "1")
           load_Items_error_end
        else
           load_Items_1  
        end         
      else             
        if !(SyncEngine::logged_in > 0)
          SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
        end 
        $sync_control = "4"
        @accts = TsdInventtabletmp.find_by_sql("DELETE FROM TsdInventtabletmp")            
        
#        Alert.show_popup(
#            :message=>  "TsdInventtabletmp |" + $Inventtable_synccount.to_s,
#            :title=>"Ошибка",
#            :buttons => ["Ok"]
#         ) 
              
        $sync_msg = "Товары: первые "  + $Inventtable_synccount.to_s + " записей"
        #WebView.execute_js("sync_msg('" + $sync_msg.to_s + "');")  
              
        SyncEngine.dosync_source(TsdInventtabletmp, true, 
          "query[param]=" + $chk_loc.to_s + "&query[param2]=" + $Inventtable_synccount.to_s + "&query[param3]=0" )        
      end
   
end

  def load_Items_3 
      redirect :controller => :Settings, :action => :wait
      @TsdInventtabletmps = TsdInventtabletmp.find(:first) 
      
      if ( @TsdInventtabletmps)
        @accts = TsdInventtable.find_by_sql("INSERT INTO TsdInventtable (ItemId, ItemName, VendId, VendName ) select ItemId, ItemName, VendId, VendName from TsdInventtabletmp")      
        $Inventtable_synccount =  $Inventtable_synccount.to_i + 5000   
        load_Items_2
      else       
        if !(SyncEngine::logged_in > 0)
          SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
        end 
        $sync_control = "5"  
        @accts = TsdInventsumtmp.find_by_sql("DELETE FROM TsdInventsumtmp")    
        
#        Alert.show_popup(
#            :message=>  "TsdInventsumtmp |" + $Inventsum_synccount.to_s,
#            :title=>"Ошибка",
#            :buttons => ["Ok"]
#         ) 

        $sync_msg = "Остатки: первые "  + $Inventsum_synccount.to_s + " записей"
        #WebView.execute_js("sync_msg('" + $sync_msg.to_s + "');")  
                              
        SyncEngine.dosync_source(TsdInventsumtmp, true, 
          "query[param]=" + $chk_loc.to_s + "&query[param2]=" + $Inventsum_synccount.to_s + "&query[param3]=0" )        
      end              
  end
  
  def load_Items_4
      redirect :controller => :Settings, :action => :wait
      @TsdInventsumtmps = TsdInventsumtmp.find(:first) 
       
      if (@TsdInventsumtmps)
        @accts = TsdInventsum.find_by_sql("INSERT INTO TsdInventsum (InventLocationId, ItemId, InventSizeId, VendCode, AvailableQty, OrderedQty) select InventLocationId, ItemId, InventSizeId, VendCode, AvailableQty, OrderedQty from TsdInventsumtmp")      
        $Inventsum_synccount =  $Inventsum_synccount.to_i + 5000   
        load_Items_3      
      else
        if !(SyncEngine::logged_in > 0)
          SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
        end 
        $sync_control = "60" 
        @accts = TsdInventpricetmp.find_by_sql("DELETE FROM TsdInventpricetmp")  
  
#        Alert.show_popup(
#            :message=>  "TsdInventpricetmp |" + $Inventprice_synccount.to_s,
#            :title=>"Ошибка",
#            :buttons => ["Ok"]
#         )        
         
        $sync_msg = "Цены: первые "  + $Inventprice_synccount.to_s + " записей"         
        #WebView.execute_js("sync_msg('" + $sync_msg.to_s + "');")  
         
        SyncEngine.dosync_source(TsdInventpricetmp, true, 
          "query[param]=" + $chk_loc.to_s + "&query[param2]=" + $Inventprice_synccount.to_s + "&query[param3]=0") 
      end  
           
  end

  def load_Items_error_end
  if ($msg == "")        
    $msg1 = "Синхронизация выполненна"
    $msg2 = ""   
    status = "0"
  else
    $msg1 = "" 
    $msg2 = $msg  
    status = "1"                 
  end

  $sync_msg = ""  

  t = Time.now

  @TsdUserinfos = TsdUserinfo.find(:first,
         :conditions => { 
         {
         :name => "UserName", 
         :op => "IN" 
         } => $chk_user       
        } )   

        count0 = TsdItembarcode.find(:count)        
        count1 = TsdInventtable.find(:count)   
        count2 = TsdInventsum.find(:count)  
        count3 = TsdInventprice.find(:count) 
                                
        # Запись в лог    
        TsdLog.create("UserId" => @TsdUserinfos.UserId, 
              "InventLocationId" => $chk_loc,
              "DeviceID" => $device_id,
              "Date" => t.strftime("%Y-%m-%d"),
              "Time" => t.strftime("%S").to_i + t.strftime("%M").to_i*60 + t.strftime("%H").to_i*3600,
              "Operation" => "5",
              "Status" => status,                  
              "Comment" => "Barcode: " + count0.to_s + " строк | " +
                           "Item: " + count1.to_s + " строк | " +
                           "Sum: " + count2.to_s + " строк | " +
                           "Price: " + count3.to_s + " строк"
              )            


              WebView.navigate( url_for :controller => :MainMenu, :action => :main_menu )   
  end
    
  def load_Items_5
      redirect :controller => :Settings, :action => :wait
      @TsdInventpricetmps = TsdInventpricetmp.find(:first) 
       
      if (@TsdInventpricetmps)
        @accts = TsdInventprice.find_by_sql("INSERT INTO TsdInventprice (InventLocationId,ItemId,InventSizeId,RetailPrice,SalesPrice,SalesDiscount,YellowLabel) select InventLocationId,ItemId,InventSizeId,RetailPrice,SalesPrice,SalesDiscount,YellowLabel from TsdInventpricetmp")      
        $Inventprice_synccount =  $Inventprice_synccount.to_i + 5000   
        load_Items_4      
      else      
#          Alert.show_popup(
#              :message=> "Выполненно |" + Time.now.to_s,
#              :title=>"Ошибка",
#              :buttons => ["Ok"]
#           ) 
           
          if ($msg == "")        
            $msg1 = "Синхронизация выполненна"
            $msg2 = ""   
            status = "0"
          else
            $msg1 = "" 
            $msg2 = $msg  
            status = "1"                 
          end
       
        $sync_msg = ""  
        
        t = Time.now
        
        @TsdUserinfos = TsdUserinfo.find(:first,
                 :conditions => { 
                 {
                 :name => "UserName", 
                 :op => "IN" 
                 } => $chk_user       
                } )   
        
        count0 = TsdItembarcode.find(:count)        
        count1 = TsdInventtable.find(:count)   
        count2 = TsdInventsum.find(:count)  
        count3 = TsdInventprice.find(:count) 
                                        
        # Запись в лог    
        TsdLog.create("UserId" => @TsdUserinfos.UserId, 
                      "InventLocationId" => $chk_loc,
                      "DeviceID" => $device_id,
                      "Date" => t.strftime("%Y-%m-%d"),
                      "Time" => t.strftime("%S").to_i + t.strftime("%M").to_i*60 + t.strftime("%H").to_i*3600,
                      "Operation" => "5",
                      "Status" => status,                  
                      "Comment" => "Barcode: " + count0.to_s + " строк | " +
                                   "Item: " + count1.to_s + " строк | " +
                                   "Sum: " + count2.to_s + " строк | " +
                                   "Price: " + count3.to_s + " строк"
                      )            
        
        #redirect :controller => :MainMenu, :action => :main_menu
      
        WebView.navigate( url_for :controller => :MainMenu, :action => :main_menu )   
      end 
  end
  
  def login_callback
    if rho_error.unknown_client?( @params['error_message'] )
      Rhom::Rhom.database_client_reset
    end  
  end 
  
 def sync_notific
   $sync_status = "0"   
     
    if (@params['status'] == "ok")
      $sync_status = "1"
    end
    
   if (@params['status'] == "error")
     $sync_status = "1"
     $msg = "Ошибка синхронизации!"
   end              
   
   if ( $sync_status == "1")
         if ($sync_control == "3") 
           load_Items_2
         end
         
         if ($sync_control == "4") 
           load_Items_3
         end
     
         if ($sync_control == "5") 
           load_Items_4
         end           
               
          if ($sync_control == "60")                       
            load_Items_5
          end       
   end
 end 
  
  
 def see
   # Поиск в справочнике товаров
   @TsdInventtables = TsdInventtable.find(:all )  
   count = 0
   
   @TsdInventtables.each do |basket|
     count = count.to_i + 1
   end    
   
   Alert.show_popup(
       :message=> "TsdInventtables |" + count.to_s,
       :title=>"Ошибка",
       :buttons => ["Ok"]
    )          
   
   # Поиск в справочнике товаров
   @TsdInventtables = TsdItembarcode.find(:all )  
   count = 0
   
   @TsdInventtables.each do |basket|
     count = count.to_i + 1
   end    
   
   Alert.show_popup(
       :message=> "TsdItembarcode |" + count.to_s,
       :title=>"Ошибка",
       :buttons => ["Ok"]
    )       
     
   # Поиск в справочнике товаров
   @TsdInventtables = TsdItembarcode2.find(:all )  
   count = 0
   
   @TsdInventtables.each do |basket|
     count = count.to_i + 1
   end    
   
   Alert.show_popup(
       :message=> "TsdItembarcode2 |" + count.to_s,
       :title=>"Ошибка",
       :buttons => ["Ok"]
    )       
    
   # Поиск в справочнике товаров
   @TsdInventtables = TsdInventsum.find(:all )  
   count = 0
   
   @TsdInventtables.each do |basket|
     count = count.to_i + 1
   end    
   
   Alert.show_popup(
       :message=> "TsdInventsum |" + count.to_s,
       :title=>"Ошибка",
       :buttons => ["Ok"]
    )     

   # Поиск в справочнике товаров
   @TsdInventtables = TsdInventprice.find(:all )  
   count = 0
   
   @TsdInventtables.each do |basket|
     count = count.to_i + 1
   end    
   
   Alert.show_popup(
       :message=> "TsdInventprice |" + count.to_s,
       :title=>"Ошибка",
       :buttons => ["Ok"]
    )  
            
   render :action => :main_menu    
 end 
  
  # Загрузка товаров и справочников
  def load_Items   
#    $Inventtable_synccount = 0
#    $Itembarcode_synccount = 0   
#    $Inventprice_synccount = 0  
#    $Inventsum_synccount = 0 
#         
#    @accts = TsdInventtable.find_by_sql("DELETE FROM TsdInventtable")   
#    @accts = TsdItembarcode.find_by_sql("DELETE FROM TsdItembarcode")      
#    @accts = TsdItembarcode2.find_by_sql("DELETE FROM TsdItembarcode2")      
#    @accts = TsdInventprice.find_by_sql("DELETE FROM TsdInventprice")  
#    @accts = TsdInventsum.find_by_sql("DELETE FROM TsdInventsum")         
 
#    TsdItembarcodetemp.set_notification(url_for(:controller => :MainMenu, :action => :sync_notific), "")         
#    TsdInventtabletmp.set_notification(url_for(:controller => :MainMenu, :action => :sync_notific), "") 
#    TsdInventpricetmp.set_notification(url_for(:controller => :MainMenu, :action => :sync_notific), "")           
#    TsdInventsumtmp.set_notification(url_for(:controller => :MainMenu, :action => :sync_notific), "")  
        
    load_Items_0                            
  end

  def load_Items_0
    if !(SyncEngine::logged_in > 0)
      SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
    end 
      
    $sync_control = "333"
     
    $sync_msg = "Проверка связи.."   
    SyncEngine.dosync_source(TsdInventlocation, false)    
  end
  
  def load_Items_00
    if ($error_status == "1")
       load_Items_error_end
    else
          $Inventtable_synccount = 0
          $Itembarcode_synccount = 0   
          $Inventprice_synccount = 0  
          $Inventsum_synccount = 0 
               
          @accts = TsdInventtable.find_by_sql("DELETE FROM TsdInventtable")   
          @accts = TsdItembarcode.find_by_sql("DELETE FROM TsdItembarcode")      
          @accts = TsdItembarcode2.find_by_sql("DELETE FROM TsdItembarcode2")      
          @accts = TsdInventprice.find_by_sql("DELETE FROM TsdInventprice")  
          @accts = TsdInventsum.find_by_sql("DELETE FROM TsdInventsum")  
            
      load_Items_1
    end    
  end
  
  def load_Items_1   
    redirect :controller => :Settings, :action => :wait
    if !(SyncEngine::logged_in > 0)
      SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
    end 
    $sync_control = "3"
    @accts = TsdItembarcodetemp.find_by_sql("DELETE FROM TsdItembarcodetemp")         
    
#          Alert.show_popup(
#              :message=>  "TsdItembarcodetemp |" + $Itembarcode_synccount.to_s,
#              :title=>"Ошибка",
#              :buttons => ["Ok"]
#           )               

    $sync_msg = "ШК: первые "  + $Itembarcode_synccount.to_s + " записей"           
    #WebView.execute_js("sync_msg('" + $sync_msg.to_s + "');")  
        
    #redirect :controller => :Settings, :action => :wait   
    SyncEngine.dosync_source(TsdItembarcodetemp, true, 
      "query[param]=" + $chk_loc.to_s + "&query[param2]=" + $Itembarcode_synccount.to_s + "&query[param3]=0" )   
  end
    
  # Загрузка товаров и справочников
  def load_receipt    
#    # Заказы шапка
#    TsdReceiptjour.delete_all()
#  
#    fileName_i = File.join(Rho::RhoApplication::get_base_app_path(), '/public/TSD_ReceiptJour.txt')
#    lines_i = File.read(fileName_i)
#    jsonContent_i = Rho::JSON.parse(lines_i)
#    jsonContent_i.each {
#      |json|
#      TsdReceiptjour.create("JourId" => json['JourId'], 
#        "InventLocationId" => json['InventLocationId'], 
#        "VendId"   => json['VendId'], 
#        "VendName" => json['VendName'],
#        "ShipDate" => json['ShipDate'],
#        "OverDelivery" => json['OverDelivery'],
#        "Deleted" => json['Deleted'],
#        "Imported" => json['Imported']          
#        )
#    }
# 
#    # Заказы шапка
#    TsdReceiptline.delete_all()
#  
#    fileName_i = File.join(Rho::RhoApplication::get_base_app_path(), '/public/TSD_ReceiptLine.txt')
#    lines_i = File.read(fileName_i)
#    jsonContent_i = Rho::JSON.parse(lines_i)
#    jsonContent_i.each {
#      |json|
#      TsdReceiptline.create("JourId" => json['JourId'], 
#        "ItemId" => json['ItemId'], 
#        "InventSizeId"   => json['InventSizeId'], 
#        "OrderPrice" => json['OrderPrice'],
#        "OrderedQty" => json['OrderedQty'],
#        "ReceivedQty" => json['ReceivedQty']          
#        )
#    }    
                   
  end
    
  # Загрузка журналов инвентаризации
  def load_Invent
    # Журнал шапка
    #TsdInventcountjour.delete_all()
  
    #fileName_i = File.join(Rho::RhoApplication::get_base_app_path(), '/public/TSD_InventCountJour.txt')
    #lines_i = File.read(fileName_i)
    #jsonContent_i = Rho::JSON.parse(lines_i)
    #jsonContent_i.each {
    #  |json|
    #  TsdInventcountjour.create("JourId" => json['JourId'], 
    #    "InventLocationId" => json['InventLocationId'], 
    #    "JourDescription"   => json['JourDescription'], 
    #    "ShipDate" => json['ShipDate'],
    #    "Deleted" => json['Deleted'],
    #    "Imported" => json['Imported']          
    #    )
    #}
 
    # Журналы позиции
    #TsdInventcountline.delete_all()
  
    #fileName_i = File.join(Rho::RhoApplication::get_base_app_path(), '/public/TSD_InventCountLine.txt')
    #lines_i = File.read(fileName_i)
    #jsonContent_i = Rho::JSON.parse(lines_i)
    #jsonContent_i.each {
    #  |json|
    #  TsdInventcountline.create("JourId" => json['JourId'], 
    #    "ItemId" => json['ItemId'],
    #    "ItemBarCode" => json['ItemBarCode'],    
    #    "InventSizeId"   => json['InventSizeId'], 
    #    "CountedQty" => json['CountedQty']          
    #    )
    #}    
                   
  end
  
  # Подготовка к выполнению проверки корзины
  def basket_work
    #Загрузка из корзины
    $basket_load_ftrom_chit = 0

    $msg = ""
    $msg1 = ""
    $msg2 = ""
    redirect :controller => :Basket, :action => :show_main_nenu_basket
  end
  
  # Приемка
  def receipt
    $picker_w = $picker_w.to_i + 1
	# Загрузка заказов на приемку
    load_receipt     
	
    # Синхронизация со справочниками товаров, цен, остатков и Ш
	  #$Menu_mode = "3"
    #load_Items   

	  #render :action => :main_menu
    $msg = ""
    $msg1 = ""
    $msg2 = ""
    
    redirect :controller => :Receipt, :action => :shk_date    
  end

  # Инвентаризация
  def invent
    $picker_o = $picker_o.to_i + 1
    # Загрузка заказов на приемку
    load_Invent   
	
    # Синхронизация со справочниками товаров, цен, остатков и Ш
	  #$Menu_mode = "4"
    #load_Items 

    $msg = ""
    $msg1 = ""
    $msg2 = ""
 
    redirect :controller => :Invent, :action => :shk_date    
  end  
     
end

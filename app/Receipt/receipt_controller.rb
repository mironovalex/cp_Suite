
require 'rho/rhocontroller'
require 'helpers/browser_helper'


class ReceiptController < Rho::RhoController
  include BrowserHelper

  def login_callback
    if rho_error.unknown_client?( @params['error_message'] )
      Rhom::Rhom.database_client_reset
    end  
  end   
  
  # Загрузить данные
  def recipt_menu_
    $DateOrder = '20' + @params['Y'].to_s() + '-' + @params['M'].to_s() + '-' + @params['D'].to_s()
    WebView.navigate(url_for(:action => :show_recipt)) 
  end
  
  # Считывание даты заказов
  def recipt_menu 
    render :action => :recipt_menu
  end
    
  def dnload_receipt_2 
    $sync_msg = "Загрузка: Заказы строки"  
    redirect :controller => :Settings, :action => :wait
    $sync_control = "10"

    if !(SyncEngine::logged_in > 0)
      SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
    end 
      SyncEngine.dosync_source( TsdReceiptlineselect, show_sync_status = true, "query[param1]=" + $chk_loc.to_s + "&query[param2]=" + $DateOrder.to_s )           
  end
  
  def dnload_receipt_3                                                                                                   
    @TsdReceiptjourselects = TsdReceiptjourselect.find(:all)
    
    @TsdReceiptjourselects.each do |jour|     
      jour.update_attributes({"Mark" => "0"})
    end
                  
    dnl_rec_one              
  end
  
  ##########################################################################
  def load_Items_0
    $Inventtable_synccount = 0
    $Itembarcode_synccount = 0   
    $Inventprice_synccount = 0  
    $Inventsum_synccount = 0 
          
    $msg = "" 
    $msg1 = "" 
    $msg2 = "" 
      
    load_Items_1  
  end
  
  def load_Items_1
    $sync_msg = "Загрузка: ШК заказы"  
    redirect :controller => :Settings, :action => :wait   
    if !(SyncEngine::logged_in > 0)
      SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
    end 
    $sync_control = "30"
    @accts = TsdItembarcodetemp.find_by_sql("DELETE FROM TsdItembarcodetemp")         
    
#          Alert.show_popup(
#              :message=>  "TsdItembarcodetemp |" + $Itembarcode_synccount.to_s,
#              :title=>"Ошибка",
#              :buttons => ["Ok"]
#           )      
    
    SyncEngine.dosync_source(TsdItembarcodetemp, true, 
      "query[param]=" + $chk_loc.to_s + "&query[param2]=" + $Itembarcode_synccount.to_s + "&query[param3]=1" )
  end
  
  def load_Items_2 
    $sync_msg = "Загрузка: Товары заказов"  
    redirect :controller => :Settings, :action => :wait   
    @TsdItembarcodetmps = TsdItembarcodetemp.find(:first) 
     
    if (@TsdItembarcodetmps)
      $Itembarcode_synccount =  $Itembarcode_synccount.to_i + 5000   

        @accts = TsdItembarcode.find_by_sql("DELETE FROM TsdItembarcode WHERE ItemBarCode in (select ItemBarCode from TsdItembarcodetemp)")                          
        @accts = TsdItembarcode.find_by_sql("INSERT INTO TsdItembarcode( ItemId, InventSizeId, ItemBarCode ) select ItemId, InventSizeId, ItemBarCode from TsdItembarcodetemp")              

      load_Items_1      
    else
      if !(SyncEngine::logged_in > 0)
        SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
      end 
      $sync_control = "40"
      @accts = TsdInventtabletmp.find_by_sql("DELETE FROM TsdInventtabletmp")            
      
#      Alert.show_popup(
#          :message=>  "TsdInventtabletmp |" + $Inventtable_synccount.to_s,
#          :title=>"Ошибка",
#          :buttons => ["Ok"]
#       ) 
        
      $sync_msg = "Загрузка: Товары заказов"  

      SyncEngine.dosync_source(TsdInventtabletmp, true, 
        "query[param]=" + $chk_loc.to_s + "&query[param2]=" + $Inventtable_synccount.to_s + "&query[param3]=1" )        
    end
end

  def load_Items_3    

    redirect :controller => :Settings, :action => :wait
    @TsdInventtabletmps = TsdInventtabletmp.find(:first) 
    
    if ( @TsdInventtabletmps)
      @accts = TsdInventtable.find_by_sql("DELETE FROM TsdInventtable WHERE ItemId in (select ItemId from TsdInventtabletmp)")      
      @accts = TsdInventtable.find_by_sql("INSERT INTO TsdInventtable (ItemId, ItemName, VendId, VendName ) select ItemId, ItemName, VendId, VendName from TsdInventtabletmp")      
      $Inventtable_synccount =  $Inventtable_synccount.to_i + 5000   
      #WebView.navigate( url_for :controller => :MainMenu, :action => :load_Items_2)
      load_Items_2
    else       
      if !(SyncEngine::logged_in > 0)
        SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
      end 
      $sync_control = "50"  
      @accts = TsdInventsumtmp.find_by_sql("DELETE FROM TsdInventsumtmp")    
      
#      Alert.show_popup(
#          :message=>  "TsdInventsumtmp |" + $Inventsum_synccount.to_s,
#          :title=>"Ошибка",
#          :buttons => ["Ok"]
#       )                 
      
      SyncEngine.dosync_source(TsdInventsumtmp, true, 
        "query[param]=" + $chk_loc.to_s + "&query[param2]=" + $Inventsum_synccount.to_s + "&query[param3]=1" )        
    end          
  end
  
  def load_Items_4
    $sync_msg = "Загрузка: Цены товаров заказы"  
        
    redirect :controller => :Settings, :action => :wait
    @TsdInventsumtmps = TsdInventsumtmp.find(:first) 
     
    if (@TsdInventsumtmps)
      @accts = TsdInventsum.find_by_sql("DELETE FROM TsdInventsum WHERE InventLocationId || ItemId || InventSizeId in (select InventLocationId||ItemId||InventSizeId from TsdInventsumtmp)")      
      @accts = TsdInventsum.find_by_sql("INSERT INTO TsdInventsum (InventLocationId, ItemId, InventSizeId, VendCode, AvailableQty, OrderedQty) select InventLocationId, ItemId, InventSizeId, VendCode, AvailableQty, OrderedQty from TsdInventsumtmp")      
      $Inventsum_synccount =  $Inventsum_synccount.to_i + 5000   
      load_Items_3      
    else
      if !(SyncEngine::logged_in > 0)
        SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
      end 
      $sync_control = "600" 
      @accts = TsdInventpricetmp.find_by_sql("DELETE FROM TsdInventpricetmp")  

#      Alert.show_popup(
#          :message=>  "TsdInventpricetmp |" + $Inventprice_synccount.to_s,
#          :title=>"Ошибка",
#          :buttons => ["Ok"]
#       ) 
      
      $sync_msg = "Загрузка: Цены товаров заказы"  
            
      SyncEngine.dosync_source(TsdInventpricetmp, true, 
        "query[param]=" + $chk_loc.to_s + "&query[param2]=" + $Inventprice_synccount.to_s + "&query[param3]=1") 
    end   
  end
  
  def load_Items_5
    redirect :controller => :Settings, :action => :wait
    @TsdInventpricetmps = TsdInventpricetmp.find(:first) 
     
    if (@TsdInventpricetmps)
      @accts = TsdInventprice.find_by_sql("DELETE FROM TsdInventprice WHERE InventLocationId||ItemId||InventSizeId in (select InventLocationId||ItemId||InventSizeId from TsdInventpricetmp)")      
      @accts = TsdInventprice.find_by_sql("INSERT INTO TsdInventprice (InventLocationId,ItemId,InventSizeId,RetailPrice,SalesPrice,SalesDiscount,YellowLabel) select InventLocationId,ItemId,InventSizeId,RetailPrice,SalesPrice,SalesDiscount,YellowLabel from TsdInventpricetmp")      
      $Inventprice_synccount =  $Inventprice_synccount.to_i + 5000   
      load_Items_4      
    else       
      #WebView.navigate( url_for :controller => :Receipt, :action => :dnload_receipts)   
      dnload_receipts                     
    end   
  end
  
 ######################################################################################   
   
  def show_recipt_
    $msg = ""
    $msg1 = ""
    $msg2 = ""
    
    WebView.execute_js("nulling();") 
    
    redirect :action => :show_recipt
  end
  
  def main_menu_
    $msg = ""
    $msg1 = ""
    $msg2 = ""
    
    WebView.execute_js("nulling();") 
    
    redirect :controller => :MainMenu, :action => :main_menu
  end  

  def main_menu_2
    $msg = ""
    $msg1 = ""
    $msg2 = ""
    
    WebView.execute_js("nulling();") 
    
    WebView.navigate(url_for(:controller => :MainMenu, :action => :main_menu)) 
    #redirect :controller => :MainMenu, :action => :main_menu
  end  
    
  
  # Загрузка данных
  def dnload_receipts 
    $sync_msg = "Загрузка: Заказы"  
    redirect :controller => :Settings, :action => :wait       
    #Загрузка заказов
    TsdReceiptjourselect.delete_all()
    TsdReceiptlineselect.delete_all()
    
    $sync_err = "0"
    $sync_err_msg = ""   
    
    $sync_control = "9"
       
    if !(SyncEngine::logged_in > 0)
      SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
    end 
      SyncEngine.dosync_source(TsdReceiptjourselect, show_sync_status = true, "query[param1]=" + $chk_loc.to_s + "&query[param2]=" + $DateOrder.to_s )   
                                                                                                                 
    #render :action => :recipt_menu 
  end
  
  def upload_receipt_01   
    # Найти все заказы
    @TsdReceiptjours = TsdReceiptjour.find(:all,
    :conditions => { 
      {
        :name => "InventLocationId", 
        :op => "IN" 
      } => $chk_loc,
      {
        :name => "ShipDate", 
        :op => "IN" 
      } => $DateOrder                 
      } )
      
    @TsdReceiptjours.each do |jour|     
      jour.update_attributes({"Mark" => "0"})  
    end  

    upload_receipt_02   
    #WebView.navigate(url_for :controller => :Receipt, :action => :recipt_menu)  
  end
  
  def upload_receipt_02
    # Найти все не обработанные заказы
    @TsdReceiptjours = TsdReceiptjour.find(:first,
    :conditions => { 
      {
        :name => "InventLocationId", 
        :op => "IN" 
      } => $chk_loc,
      {
        :name => "ShipDate", 
        :op => "IN" 
      } => $DateOrder,
      {
        :name => "Mark", 
        :op => "IN" 
      } => "0"                        
      } )  
          
      
   if (@TsdReceiptjours)
     @TsdReceiptjourselects = TsdReceiptjourselect.find(:first,
     :conditions => { 
       {
         :name => "JourId", 
         :op => "IN" 
       } => @TsdReceiptjours.JourId                  
       } )       
       
     # Заказа нет в хосте  
     if (!@TsdReceiptjourselects)
       @TsdReceiptlinesselects = TsdReceiptlineselect.find(:all,
       :conditions => { 
         {
           :name => "JourId", 
           :op => "IN" 
         } => @TsdReceiptjours.JourId                  
         } )        
       
      count = "0"   
       @TsdReceiptlinesselects.each do |row|
         count = count.to_i + row.ReceivedQty.to_i
       end   
      
       # По заказу нет принятых позиций
       if (count == "0")
         j = @TsdReceiptjours.JourId
         @TsdReceiptjours.update_attributes({"Mark" => "1"})
         TsdReceiptline.delete_all(:conditions => {'JourId'=> j })
         TsdReceiptjour.delete_all(:conditions => {'JourId'=> j })  
                       
         upload_receipt_02 
       else
         $JourId =  @TsdReceiptjours.JourId 
         
         Alert.show_popup(
           :message=> "Заказа " + @TsdReceiptjours.JourId.to_s + " нет в хост системе, но он принят. Удалить заказ?",
           :title=>"Внимание",
           :buttons => ["ДА", "HET"],
           :callback => url_for(:action => :on_update_receipt_01)
           )            
                                             
       end
                                        
     else 
       @TsdReceiptjours.update_attributes({"Mark" => "1"})  
       upload_receipt_02   
     end
                               
   else     
     # Синхронизация завершена
     if ($msg = "")        
       $msg1 = "Синхронизация выполненна"
       $msg2 = ""  
       status = "0" 
     else
       $msg1 = "" 
       $msg2 = $msg
       status = "1"                   
     end    
     
     count0 = TsdReceiptjour.find(:count) 
     count1 = TsdReceiptline.find(:count) 
               
     # Запись в лог    
     t = Time.now        
     
     TsdLog.create("UserId" => $chk_userid, 
                   "InventLocationId" => $chk_loc,
                   "DeviceID" => $device_id,
                   "Date" => t.strftime("%Y-%m-%d"),
                   "Time" => t.strftime("%S").to_i + t.strftime("%M").to_i*60 + t.strftime("%H").to_i*3600,
                   "Operation" => "8",
                   "Status" =>  status,                      
                   "Comment" => "TsdReceiptjours: " + count0.to_s + " строк | " +
                                "TsdReceiptline: " + count1.to_s + " строк")        
     
#       if ($sync_err == "0")     

         $sync_msg = ""           
         $sync_control == "-1"  
#       end 
                   
        
       #WebView.navigate(url_for :controller => :Receipt, :action => :recipt_menu)      
       WebView.navigate(url_for :controller => :Receipt, :action => :show_recipt)     
   end   
              
  end
  
  def dnl_rec_one
    # Обработка загрузки              
    @TsdReceiptjourselects = TsdReceiptjourselect.find(:first,      
      :conditions => { 
    {
      :name => "Mark", 
      :op => "IN" 
    } => "0"         
    } )      
    
    # Новых заказов нет
    if (!@TsdReceiptjourselects)
      #-----------------------------------------------------------------   
      #@Tsd = TsdReceiptjourselect.find(:all)      
      
      #@Tsd.each do |rec|
      #  Alert.show_popup(
      #      :message=> rec,
      #      :title=>"Ошибка",
      #      :buttons => ["Ok"]
      #   )         
      #end
      
#    # Запись в лог    
#    t = Time.now        
#    
#    TsdLog.create("UserId" => $chk_userid, 
#                  "InventLocationId" => $chk_loc,
#                  "DeviceID" => $device_id,
#                  "Date" => t.strftime("%Y-%m-%d"),
#                  "Time" => t.strftime("%S").to_i + t.strftime("%M").to_i*60 + t.strftime("%H").to_i*3600,
#                  "Operation" => "5",
#                  "Status" =>  $sync_err,                      
#                  "Comment" => $sync_err_msg.to_s)        
#	  
#      if ($sync_err == "0")
#        Alert.show_popup(
#            :message=> "Синхронизация успешно выполнена",
#            :title=>"Сообщение",
#            :buttons => ["Ok"]
#         ) 
#         
#        $sync_control == "-1"  
#      end 
        
      #WebView.navigate(url_for :controller => :Receipt, :action => :recipt_menu) 
      upload_receipt_01                             
#====================================================================================================    
    else
       jour = @TsdReceiptjourselects                    
      
      @TsdReceiptjours = TsdReceiptjour.find(:first,
      :conditions => { 
        {
          :name => "JourId", 
          :op => "IN" 
        } => jour.JourId         
        } )
              
      @TsdReceiptlines = TsdReceiptline.find(:all,
      :conditions => { 
        {
          :name => "JourId", 
          :op => "IN" 
        } => jour.JourId         
        } )
        
      count = "0"  
        
      @TsdReceiptlines.each do |row|
        count = count.to_i + row.ReceivedQty.to_i
      end          
              
	  # Если заказ непринят  
      if (count.to_i == 0)
        jour.update_attributes({"Mark" => "1"})
       
        # Удалить заказ
        TsdReceiptjour.delete_all(:conditions => {'JourId'=> jour.JourId })          
          
       # скопировать запись в БД
             TsdReceiptjour.create("JourId" => jour.JourId, 
               "InventLocationId" => jour.InventLocationId, 
               "VendId"   => jour.VendId, 
               "VendName" => jour.VendName,
               "ShipDate" => $DateOrder, #jour.ShipDate,
               "OverDelivery" => jour.OverDelivery,
               "Deleted" => jour.Deleted,
               "Imported" => jour.Imported,
               "Importeds" => "0"                 
               )        
 
      # Удалить все строки по заказу
      TsdReceiptline.delete_all(:conditions => {'JourId'=> jour.JourId })
        
      @TsdReceiptjourlineselects = TsdReceiptlineselect.find(:all, 
        :conditions => { 
          {
            :name => "JourId", 
            :op => "IN" 
          } => jour.JourId         
          } )        
      
      @TsdReceiptjourlineselects.each do |line| 
        TsdReceiptline.create("JourId" => line.JourId, 
          "ItemId" => line.ItemId, 
          "InventSizeId"   => line.InventSizeId, 
          "OrderPrice" => line.OrderPrice,
          "OrderedQty" => line.OrderedQty,
          "ReceivedQty" => "0"
          )           
       end 

       dnl_rec_one	   
      else	 
	   # Если заказ уже есть в БД   
	   if (@TsdReceiptjours)
       #--------------------------------------------------------------------------    
       flag ="0"
       
       @TsdReceiptjourselects = TsdReceiptjourselect.find(:first,
       :conditions => { 
         {
           :name => "JourId", 
           :op => "IN" 
         } => jour.JourId         
         } )        

       if (@TsdReceiptjourselects.VendId != @TsdReceiptjours.VendId)
         flag = "1"
       end  
       if (@TsdReceiptjourselects.VendName != @TsdReceiptjours.VendName)
         flag = "1"
       end  
                
       @TsdReceiptlines = TsdReceiptline.find(:all,
       :conditions => { 
         {
           :name => "JourId", 
           :op => "IN" 
         } => jour.JourId         
         } )       
       
       @TsdReceiptlineaelects = TsdReceiptlineselect.find(:all,
       :conditions => { 
         {
           :name => "JourId", 
           :op => "IN" 
         } => jour.JourId         
         } )  
         
		 count1 = "0"
         @TsdReceiptlines.each do |row|
            count1 = count1.to_i + row.OrderedQty.to_i
         end  

		 count2 = "0"
         @TsdReceiptlineaelects.each do |row|
            count2 = count2.to_i + row.OrderedQty.to_i
         end 
		 
         if (count1 != count2)
           flag = "1"
         end   
         
       $JourId = jour.JourId     

       if ( flag == "1")       
         Alert.show_popup(
           :message=> "Заказ " + jour.JourId.to_s + " был изменен. Перезагрузить?",
           :title=>"Внимание",
           :buttons => ["ДА", "HET"],
           :callback => url_for(:action => :on_update_receipt)
           )  
        else
          jour.update_attributes({"Mark" => "1"})
		      dnl_rec_one
        end
		
     else
       jour.update_attributes({"Mark" => "1"})
       
       # скопировать запись в БД
             TsdReceiptjour.create("JourId" => jour.JourId, 
               "InventLocationId" => jour.InventLocationId, 
               "VendId"   => jour.VendId, 
               "VendName" => jour.VendName,
               "ShipDate" => $DateOrder, #jour.ShipDate,
               "OverDelivery" => jour.OverDelivery,
               "Deleted" => jour.Deleted,
               "Imported" => jour.Imported,
               "Importeds" => "0"   
               )        
 
      # Удалить все строки по заказу
      TsdReceiptline.delete_all(:conditions => {'JourId'=> jour.JourId })
        
      @TsdReceiptjourlineselects = TsdReceiptlineselect.find(:all, 
        :conditions => { 
          {
            :name => "JourId", 
            :op => "IN" 
          } => jour.JourId         
          } )        
      
      @TsdReceiptjourlineselects.each do |line|
        TsdReceiptline.create("JourId" => line.JourId, 
          "ItemId" => line.ItemId, 
          "InventSizeId"   => line.InventSizeId, 
          "OrderPrice" => line.OrderPrice,
          "OrderedQty" => line.OrderedQty,
          "ReceivedQty" => "0"
          )           
       end 
       dnl_rec_one		   
     end       
     end

	  
    end
    
  end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  def on_update_receipt
         
    jour = TsdReceiptjourselect.find(:first, 
    :conditions => { 
      {
        :name => "JourId", 
        :op => "IN" 
      } => $JourId         
      } )
    
    jour.update_attributes({"Mark" => "1"})  
          
    if (@params['button_id'] == 'HET')
 
    else        
      # Удалить заказ
      TsdReceiptjour.delete_all(:conditions => {'JourId'=> jour.JourId })        
        
      # скопировать запись в БД
            TsdReceiptjour.create("JourId" => jour.JourId, 
              "InventLocationId" => jour.InventLocationId, 
              "VendId"   => jour.VendId, 
              "VendName" => jour.VendName,
              "ShipDate" => $DateOrder, #jour.ShipDate,
              "OverDelivery" => jour.OverDelivery,
              "Deleted" => jour.Deleted,
              "Imported" => jour.Imported,
              "Importeds" => "0" 
              )        
                          
    # Удалить все строки по заказу               
    TsdReceiptline.delete_all(:conditions => {'JourId'=> jour.JourId }) 
 
     @TsdReceiptjourlineselects = TsdReceiptlineselect.find(:all, 
       :conditions => { 
         {
           :name => "JourId", 
           :op => "IN" 
         } => jour.JourId         
         } )        
     
     @TsdReceiptjourlineselects.each do |line|
       TsdReceiptline.create("JourId" => line.JourId, 
         "ItemId" => line.ItemId, 
         "InventSizeId"   => line.InventSizeId, 
         "OrderPrice" => line.OrderPrice,
         "OrderedQty" => line.OrderedQty,
         "ReceivedQty" => "0"
         )           
      end       
    end
        
    dnl_rec_one
  end  
  
 #----------------------------------------------------------------------------------------------------- 
  
  def on_update_receipt_01
         
    jour = TsdReceiptjour.find(:first, 
    :conditions => { 
      {
        :name => "JourId", 
        :op => "IN" 
      } => $JourId         
      } )
    
    jour.update_attributes({"Mark" => "1"})  
          
    if (@params['button_id'] == 'HET')
 
    else        
      # Удалить заказ
      j = $JourId
      TsdReceiptline.delete_all(:conditions => {'JourId'=> j })
      TsdReceiptjour.delete_all(:conditions => {'JourId'=> j })  
    end
        
    upload_receipt_02
  end  
 
  
#  # Подготовка к показу шапки заказа
  def show_detail  
#    $msg = ""
#    $msg1 = ""
#    $msg2 = ""
       
    @TsdReceiptjours = TsdReceiptjour.find(@params['id'])          
    $TsdReceiptjourObj = @params['id']  
      
    @JourId =  ""
   
    @VendId =   "" 
    @ShipDate = ""   
    
    @OrderedQty   = "0"
    @ReceivedQty  = "0"
    
    @IsReceived = "0"
    @Imported   = "0"               
    
    if (@TsdReceiptjours)
      @JourId =  @TsdReceiptjours.JourId
      
       @VendId =   @TsdReceiptjours.VendName
       @ShipDate = @TsdReceiptjours.ShipDate   
       
       @Imported = @TsdReceiptjours.Importeds
     end
        
     
    # Расчет принятого и планового кол-ва
    @TsdReceiptlines = TsdReceiptline.find(:all,
             :conditions => { 
             {
             :name => "JourId", 
             :op => "IN" 
             } => @JourId        
            } )      
                                
     if (@TsdReceiptlines)
       @TsdReceiptlines.each do |receipt|             
         @OrderedQty = @OrderedQty.to_i + receipt.OrderedQty.to_i
         @ReceivedQty = @ReceivedQty.to_i + receipt.ReceivedQty.to_i
       end              
     end
     
    if (@ReceivedQty.to_i == 0)
      @IsReceived = "Нет"
    else
      @IsReceived = "Да"         
    end  

    if (@Imported == "0")
      @Imported = "Нет"
    else
      @Imported = "Да"         
    end  
     
    render :action => :show_detail       
  end

  # Запрос на обнуление заказа
  def null_receipt
    $msg = ""
    $msg1 = ""
    $msg2 = ""
    
    WebView.execute_js("nulling();") 
    
    @TsdReceiptjours = TsdReceiptjour.find( $TsdReceiptjourObj)     

    Alert.show_popup(
        :message=> "Заказ " + @TsdReceiptjours.JourId + " будет обнулен. Продолжить?",
        :title=>"Внимание",
        :buttons => ["ДА", "HET"],
        :callback => url_for(:action => :on_null_receipt_check)
        )         
  end  
  
  # Обнуление заказа
  def on_null_receipt_check 
    if (@params['button_id'] == 'HET')
      WebView.navigate(url_for(:action => :show_detail, :id => $TsdReceiptjourObj)) 
    else
      @TsdReceiptjours = TsdReceiptjour.find( $TsdReceiptjourObj)    
      @TsdReceiptlines = TsdReceiptline.find(:all,
      :conditions => { 
        {
          :name => "JourId", 
          :op => "IN" 
        } => @TsdReceiptjours.JourId                                 
      })       
      
      @TsdReceiptjours.update_attributes({"Importeds" => "0"})         
      
      @TsdReceiptlines.each do |line|
        line.update_attributes({"ReceivedQty" => "0"}) 
      end
      
      WebView.navigate(url_for(:action => :show_detail, :id => $TsdReceiptjourObj))                
    end
    
  end  
  
  def code_str (str)
    ret = str
      
    
 #   ret = ret.gsub("\u0140","@");
         
      
    i=0
    while i < str.size
    
      Alert.show_popup(
          :message=> str[i..i.to_i+1].to_s,
          :title=>"Ошибка",
          :buttons => ["Ok"]
       )          
#      
#    a = ""  
#        
#    if (str[i..i].to_s == "А")
#      a = "01"  end
#      
#      
#      ret = ret.to_s + a.to_s
      i = i.to_i + 2
    end    
      
    #ret = "1";
    
#    a = ret.codepoints.to_a
#    b = a.map {|c| c.chr("utf-8")}.inject(:+)
#    


      
       
#    Alert.show_popup(
#        :message=> ret,
#        :title=>"Ошибка",
#        :buttons => ["Ok"]
#     )     
            
#    ret = ret.gsub("Б","BB");
#    ret = ret.gsub("В","CC");
#    ret = ret.gsub("Г","DD");
#    ret = ret.gsub("Д","EE");
#    ret = ret.gsub("Е","%F");
#    ret = ret.gsub("Ё","%J");
#    ret = ret.gsub("Ж","%H");
#    ret = ret.gsub("З","%I");
#    ret = ret.gsub("И","%J");
#    ret = ret.gsub("К","%K");
#    ret = ret.gsub("Л","%L");
#    ret = ret.gsub("М","%M");
#    ret = ret.gsub("Н","%N");
#    ret = ret.gsub("О","%O");   
#    ret = ret.gsub("П","%P");
#    ret = ret.gsub("Р","%Q");
#    ret = ret.gsub("С","%R");
#    ret = ret.gsub("Т","%S");    
#    ret = ret.gsub("У","%T");
#    ret = ret.gsub("Ф","%U");
#    ret = ret.gsub("Х","%V");
#    ret = ret.gsub("Т","%X");
#    ret = ret.gsub("Ц","%`");
#    ret = ret.gsub("Ч","%~");
#    ret = ret.gsub("Ш","%!");
#    ret = ret.gsub("Щ","%@");
#    ret = ret.gsub("ь","%#");
#    ret = ret.gsub("Ъ","%№");
#    ret = ret.gsub("Э","%$");
#    ret = ret.gsub("Ю","%;");
#    ret = ret.gsub("Я","%:");
#
#    ret = ret.gsub("а","[A");
#    ret = ret.gsub("б","[B");
#    ret = ret.gsub("в","[C");
#    ret = ret.gsub("г","[D");
#    ret = ret.gsub("д","[E");
#    ret = ret.gsub("е","[F");
#    ret = ret.gsub("ё","[J");
#    ret = ret.gsub("ж","[H");
#    ret = ret.gsub("з","[I");
#    ret = ret.gsub("и","[J");
#    ret = ret.gsub("к","[K");
#    ret = ret.gsub("л","[L");
#    ret = ret.gsub("м","[M");
#    ret = ret.gsub("н","[N");
#    ret = ret.gsub("о","[O");   
#    ret = ret.gsub("п","[P");
#    ret = ret.gsub("р","[Q");
#    ret = ret.gsub("с","[R");
#    ret = ret.gsub("т","[S");    
#    ret = ret.gsub("у","[T");
#    ret = ret.gsub("ф","[U");
#    ret = ret.gsub("х","[V");
#    ret = ret.gsub("т","[X");
#    ret = ret.gsub("ц","[`");
#    ret = ret.gsub("ч","[~");
#    ret = ret.gsub("ш","[!");
#    ret = ret.gsub("щ","[@");
#    ret = ret.gsub("ь","[#");
#    ret = ret.gsub("ъ","[№");
#    ret = ret.gsub("э","[$");
#    ret = ret.gsub("ю","[;");
#    ret = ret.gsub("я","[:");    
          
    
    return ret
  end
  
  #-----------------------------------------------------------------------------------------------

   def upload_receipt_2
   $sync_msg = "Выгрузка: Запрос строки"  
   redirect :controller => :Settings, :action => :wait
	 if !(SyncEngine::logged_in > 0)
       SyncEngine.login("1", "1", (url_for :action => :login_callback) )
     end
      $sync_control = "12"
      SyncEngine.dosync_source( TsdReceiptlineselect, show_sync_status = true, "query[param1]=" + $JourId.to_s )
	  
	 #render :action => :show_detail, :id => $TsdReceiptjourObj
	end

  def upload_receipt_3   
    $sync_msg = "Выгрузка: Заказ"  
    redirect :controller => :Settings, :action => :wait
    
    @TsdReceiptjours = TsdReceiptjour.find( $TsdReceiptjourObj)     
    @TsdReceiptlines = TsdReceiptline.find(:all,
      :conditions => { 
        {
          :name => "JourId", 
          :op => "IN" 
        } => @TsdReceiptjours.JourId                                 
      }) 
                     
    @TsdReceiptjourselects = TsdReceiptjourselect.find(:first,
      :conditions => { 
        {
          :name => "JourId", 
          :op => "IN" 
        } => @TsdReceiptjours.JourId                                 
      }) 
            
    @TsdReceiptlineselects = TsdReceiptlineselect.find(:all,
      :conditions => { 
        {
          :name => "JourId", 
          :op => "IN" 
        } => @TsdReceiptjours.JourId                                 
      }
      ) 		  
	   
	count = "0"
#	@TsdReceiptlineselects.each do |row|
#	  count = count.to_i + row.ReceivedQty.to_i
#	end  	
	 	
	
	if (@TsdReceiptjourselects.Imported == "1")
	  count = "1"
	end
	
#    Alert.show_popup(
#        :message=> @TsdReceiptjourselects,
#        :title=>"Ошибка",
#        :buttons => ["Ok"]
#     ) 	
	  
	
	# ранее выгружен
	if (count.to_i > 0)
	    Alert.show_popup(
           :message=> "Заказ " + $JourId.to_s + " уже был принят и выгружен. Перевыгрузить?",
           :title=>"Внимание",
           :buttons => ["ДА", "HET"],
           :callback => url_for(:action => :upload_receipt_6)
           ) 
	else
	####################################################################################
  @TsdReceiptjours = TsdReceiptjour.find( $TsdReceiptjourObj)   
  @TsdReceiptjours.update_attributes({"Imported" => "1"})   
  @TsdReceiptjours.update_attributes({"Importeds" => "1"})  
	  
	# Перезапись
	TsdReceiptjourtmp.delete_all();
	TsdReceiptlinetmp.delete_all();
	
	TsdReceiptjourtmp.create("JourId" =>  @TsdReceiptjours.JourId.to_s, 
        "InventLocationId" => @TsdReceiptjours.InventLocationId.to_s, 
        "VendId"   => @TsdReceiptjours.VendId.to_s, 
        "VendName" => @TsdReceiptjours.VendName.to_s,
        "ShipDate" => @TsdReceiptjours.ShipDate.to_s,
        "OverDelivery" => @TsdReceiptjours.OverDelivery.to_s,
        "Deleted" => @TsdReceiptjours.Deleted.to_s,
        "Imported" => "1"          
        )

	@TsdReceiptlines.each do |row|
      TsdReceiptlinetmp.create("JourId" => row.JourId.to_s, 
        "ItemId" => row.ItemId.to_s, 
        "InventSizeId"   => row.InventSizeId.to_s, 
        "OrderPrice" => row.OrderPrice.to_s,
        "OrderedQty" => row.OrderedQty.to_s,
        "ReceivedQty" => row.ReceivedQty.to_s          
       )
       
    TsdReceiptjourtmp.delete_all();
    TsdReceiptlinetmp.delete_all();       
	end
	
	if !(SyncEngine::logged_in > 0)
      SyncEngine.login("1", "1", (url_for :action => :login_callback) )
    end
    $sync_control = "13"
    SyncEngine.dosync_source( TsdReceiptjourtmp, show_sync_status = true, "query[param1]=" + $JourId.to_s )
	end
end
	
  def upload_receipt_4
    $sync_msg = "Выгрузка: Заказ строки"    
  redirect :controller => :Settings, :action => :wait
	if !(SyncEngine::logged_in > 0)
      SyncEngine.login("1", "1", (url_for :action => :login_callback) )
    end
    $sync_control = "14"
    SyncEngine.dosync_source( TsdReceiptlinetmp, show_sync_status = true, "query[param1]=" + $JourId.to_s )  
  end

  def upload_receipt_5
    if ($msg = "")        
      $msg1 = "Синхронизация выполненна"
      $msg2 = ""  
      status = "0" 
    else
      $msg1 = "" 
      $msg2 = $msg
      status = "1"                   
    end  
    
      # Запись в лог    
    t = Time.now        
    
    TsdLog.create("UserId" => $chk_userid, 
                  "InventLocationId" => $chk_loc,
                  "DeviceID" => $device_id,
                  "Date" => t.strftime("%Y-%m-%d"),
                  "Time" => t.strftime("%S").to_i + t.strftime("%M").to_i*60 + t.strftime("%H").to_i*3600,
                  "Operation" => "9",
                  "Status" =>  status,                      
                  "Comment" => $sync_err_msg.to_s + " Заказ: " + $JourId.to_s)  
  
#      if ($sync_err == "0")
  
    $sync_msg = ""           
           
         
#    Alert.show_popup(
#        :message=> $msg1.to_s + $msg2.to_s,
#        :title=>"Сообщение",
#        :buttons => ["Ok"]
#     )         
                
    #redirect :controller => :Receipt, :action => :show_detail, :id => $TsdReceiptjourObj  
  	WebView.navigate( url_for :controller => :Receipt, :action => :show_detail, :id => $TsdReceiptjourObj)	 
  end  

  def show_recipt_
    $msg = ""
    $msg1 = ""
    $msg2 = ""
    WebView.execute_js("nulling();")    
    redirect :action => :show_recipt
  end
  
  def show_recipt_2
    $msg = ""
    $msg1 = ""
    $msg2 = ""
    WebView.execute_js("nulling();") 
    WebView.navigate(url_for(:action => :show_recipt))    
    #redirect :action => :show_recipt
  end 
  
  def upload_receipt_6
    redirect :controller => :Settings, :action => :wait
    @TsdReceiptjours = TsdReceiptjour.find( $TsdReceiptjourObj) 
    @TsdReceiptlines = TsdReceiptline.find(:all,
      :conditions => { 
        {
          :name => "JourId", 
          :op => "IN" 
        } => @TsdReceiptjours.JourId                                 
      }) 
	  
    if (@params['button_id'] == 'HET')
      upload_receipt_5
	  #WebView.navigate( url_for :controller => :Receipt, :action => :show_detail, :id => $TsdReceiptjourObj)
    else 
    @TsdReceiptjours = TsdReceiptjour.find( $TsdReceiptjourObj)   
    @TsdReceiptjours.update_attributes({"Imported" => "1"})   
    @TsdReceiptjours.update_attributes({"Importeds" => "1"})    
	# Перезапись
	TsdReceiptjourtmp.delete_all();
	TsdReceiptlinetmp.delete_all();
      	
	TsdReceiptjourtmp.create("JourId" =>  @TsdReceiptjours.JourId.to_s, 
        "InventLocationId" => @TsdReceiptjours.InventLocationId.to_s, 
        "VendId"   => @TsdReceiptjours.VendId.to_s, 
        "VendName" => @TsdReceiptjours.VendName.to_s,
        "ShipDate" => @TsdReceiptjours.ShipDate.to_s,
        "OverDelivery" => @TsdReceiptjours.OverDelivery.to_s,
        "Deleted" => @TsdReceiptjours.Deleted.to_s,
        "Imported" => "1"          
        )

	@TsdReceiptlines.each do |row|
#        Alert.show_popup(
#            :message=> row,
#            :title=>"Сообщение",
#            :buttons => ["Ok"]
#         )   	  
      TsdReceiptlinetmp.create("JourId" => row.JourId.to_s, 
        "ItemId" => row.ItemId.to_s, 
        "InventSizeId"   => row.InventSizeId.to_s, 
        "OrderPrice" => row.OrderPrice.to_s,
        "OrderedQty" => row.OrderedQty.to_s,
        "ReceivedQty" => row.ReceivedQty.to_s          
       )
       
    TsdReceiptjourtmp.delete_all();
    TsdReceiptlinetmp.delete_all();    
	end
	
	if !(SyncEngine::logged_in > 0)
      SyncEngine.login("1", "1", (url_for :action => :login_callback) )
    end
    $sync_control = "13"
    SyncEngine.dosync_source( TsdReceiptjourtmp, show_sync_status = true, "query[param1]=" + $JourId.to_s )	
	end
  end
		
  # Выгрузка заказа
  def upload_receipt
    $msg = ""
    $msg1 = ""
    $msg2 = ""
    
    $sync_msg = "Выгрузка: Запрос" 
    
    WebView.navigate( url_for( :controller => :Settings, :action => :wait ) )
    
    @TsdReceiptjours = TsdReceiptjour.find( $TsdReceiptjourObj)   
    #@TsdReceiptjours.update_attributes({"Imported" => "1"})   
    #@TsdReceiptjours.update_attributes({"Importeds" => "1"})         
  	$JourId = @TsdReceiptjours.JourId
	
	TsdReceiptjourselect.delete_all();
	TsdReceiptlineselect.delete_all();	
	
    if !(SyncEngine::logged_in > 0)
      SyncEngine.login("1", "1", (url_for :action => :login_callback) )
    end
    $sync_control = "11"
    SyncEngine.dosync_source( TsdReceiptjourselect, show_sync_status = true, "query[param1]=" + $chk_loc.to_s + "&query[param2]=" + $DateOrder.to_s )
	
#	render :action => :show_detail, :id => $TsdReceiptjourObj
    #WebView.navigate(url_for(:action => :show_detail, :id => $TsdReceiptjourObj))      
  end
  
  #-----------------------------------------------------------------------------------------------
  
  # Приемка товара
  def begin_receipt
    $msg = ""
    $msg1 = ""
    $msg2 = ""
    
    $po_cycle_check = "0"
    $in_cycle_check = "0"  
    
    WebView.execute_js("nulling();") 
    ##WebView.navigate(url_for(:action => :inp_item)) 
    $mstatus = 'R_IS'
    WebView.navigate(url_for(:action => :R_UNI))                  
  end
    
  # переход к просмотру товара
  def before_inp_item
    $msg = ""
    redirect :action => :inp_item
  end
   
  # Подготовка к открытию формы
  def inp_item
    if !System.get_property('is_emulator')
      Scanner.disable
      Scanner.decodeEvent = url_for(:action => :decode_item)
      Scanner.enable
    end              
    
    WebView.execute_js("null_val();")  
    render
  end

  def R_UNI_
    if !System.get_property('is_emulator')
      Scanner.disable
      Scanner.decodeEvent = url_for(:action => :decode_item)
      #Scanner.decodeEvent = url_for(:action => :decode_line)      
      Scanner.enable
    end 
  end
  
  # Подготовка к открытию формы
  def R_UNI
    if !System.get_property('is_emulator')
      Scanner.disable
      Scanner.decodeEvent = url_for(:action => :decode_item)
      #Scanner.decodeEvent = url_for(:action => :decode_line)      
      Scanner.enable
    end              
    
    WebView.execute_js("null_shval();")  
  end  
    
  # Ввод товара
  def line_edit
    @@ItemId =  ""
    @@InventSizeId = ""
        
    @TsdReceiptjours = TsdReceiptjour.find( $TsdReceiptjourObj) 
    @@JourId = @TsdReceiptjours.JourId
    
    # Не ввели код
    if (@params["SH"] != "")
      
      # Поиск записи в справочнике ШК
      @TSDItembarcodes = TsdItembarcode.find(:first,
               :conditions => { 
               {
               :name => "ItemBarCode", 
               :op => "IN" 
               } => @params["SH"]        
              } )      
                                  
       if (!@TSDItembarcodes)
#         Alert.show_popup(
#             :message=> "ШК нет в справочнике!",
#             :title=>"Ошибка",
#             :buttons => ["Ok"]
#          ) 

                           
          $msg = "ШК нет в справочнике!" 
          WebView.execute_js("alarm();")  
          WebView.execute_js("msgr('" + $msg.to_s + "');") 
         WebView.execute_js("SH('" + @params["SH"].to_s + "');")
          #WebView.execute_js("TO_I();")   
       else
         @@ItemId =  @TSDItembarcodes.ItemId
         @@InventSizeId = @TSDItembarcodes.InventSizeId
         
         # Один ли в справочнике размеров
         if (@@InventSizeId != '')
           @TsdReceiptlines = TsdReceiptline.find(:first,
                    :conditions => { 
                    {
                    :name => "ItemId", 
                    :op => "IN" 
                    } =>  @@ItemId,
                    {
                    :name => "InventSizeId", 
                    :op => "IN" 
                    } =>  @@InventSizeId,                  
                    {
                    :name => "JourId", 
                    :op => "IN" 
                    } => @@JourId                                                                    
                    } ) 
         else
           @TsdReceiptlines = TsdReceiptline.find(:first,
                    :conditions => { 
                    {
                    :name => "ItemId", 
                    :op => "IN" 
                    } =>  @@ItemId,                 
                    {
                    :name => "JourId", 
                    :op => "IN" 
                    } => @@JourId                                                                    
                    } )            
         end
         
  
         if (!@TsdReceiptlines)
#           Alert.show_popup(
#               :message=> "Введенного товара нет в заказе!",
#               :title=>"Ошибка",
#               :buttons => ["Ok"]
#            ) 
            
            $msg = "Введенного товара нет в заказе!"
            WebView.execute_js("alarm();")  
            WebView.execute_js("msgr('" + $msg.to_s + "');") 
            WebView.execute_js("SH('" + @params["SH"].to_s + "');")  
            ##render :action => :inp_item
         else                    
           ##redirect :action => :do_receipt 
           _do_receipt
                   
           WebView.execute_js("ItemName('" + @ItemName.gsub(/["']/,"").to_s + "');")                 
           WebView.execute_js("ItemId('" + @ItemId.to_s + "');")  
           WebView.execute_js("InventSizeId('" + @InventSizeId.to_s + "');")  
           WebView.execute_js("VendCode('" + @VendCode.gsub(/["']/,"").to_s + "');")                                                                                                  
           WebView.execute_js("R_QTY('" + @ReceivedQty.to_s + "');")                                                         
           WebView.execute_js("OrderPrice('" + sprintf("%20.2f", @OrderPrice).to_s + "');")                               
           WebView.execute_js("OrderedQty('" + @OrderedQty.to_s + "');")
           
           #WebView.execute_js("SH('" + @TSDItembarcodes.ItemBarCode.to_s + "');") 
           #WebView.execute_js("TO_R();")  
           WebView.execute_js("ENT_PR();")  
         end
       end       
    else      
      # Поиск записи в справочнике ШК
      if (@params["SIZE"] == "")
        @TSDItembarcodes = TsdItembarcode.find(:first,
                 :conditions => { 
                 {
                 :name => "ItemId", 
                 :op => "IN" 
                 } => @params["CODE"]               
                } ) 
      else
        @TSDItembarcodes = TsdItembarcode.find(:first,
                 :conditions => { 
                 {
                 :name => "ItemId", 
                 :op => "IN" 
                 } => @params["CODE"],
                 {
                   :name => "InventSizeId", 
                   :op => "IN" 
                 } =>  @params["SIZE"]                
                } ) 
      end
     
                                  
       if (!@TSDItembarcodes)
#         Alert.show_popup(
#             :message=> "Номенклатуры нет в справочнике!",
#             :title=>"Ошибка",
#             :buttons => ["Ok"]
#          ) 
          $msg = "Номенклатуры нет в справочнике!"
          WebView.execute_js("alarm();")  
          WebView.execute_js("msgr('" + $msg.to_s + "');")   
          WebView.execute_js("SH('" + '' + "');")
          ##render :action => :inp_item
       else
         @@ItemId =  @TSDItembarcodes.ItemId
         @@InventSizeId = @TSDItembarcodes.InventSizeId        
         
         # Один ли в заказе
         #@TsdReceiptlines = TsdReceiptline.find(:all,
         @TsdReceiptlines = TsdReceiptline.find(:first,  
                  :conditions => { 
                  {
                  :name => "ItemId", 
                  :op => "IN" 
                  } =>  @@ItemId,
                  {
                    :name => "JourId", 
                    :op => "IN" 
                  } => @@JourId                                                                    
                  } )
                  
                          
         flag = "0"  
         i = "0"
         
           @TsdReceiptlines.each do |rec|
             i = i.to_i + 1
           end
           
           if (i.to_i == 0)  
             flag = "0" 
           end

           if (i.to_i == 1)  
             flag = "1" 
           end
           
           if (i.to_i > 1)  
             flag = "2" 
           end                      

         flag = "1"            
           
         if (flag == "1") 
           _do_receipt
                     
           #@OrderPrice = sprintf("%20.2f", @OrderPrice)
           
           # Перейти на страницу приемки товара
           WebView.execute_js("ItemName('" + @ItemName.gsub(/["']/,"").to_s + "');")                 
           WebView.execute_js("ItemId('" + @ItemId.to_s + "');")  
           WebView.execute_js("InventSizeId('" + @InventSizeId.to_s + "');")  
           WebView.execute_js("VendCode('" + @VendCode.gsub(/["']/,"").to_s + "');")                                                                                                  
           WebView.execute_js("R_QTY('" + @ReceivedQty.to_s + "');")                                                         
           WebView.execute_js("OrderPrice('" + sprintf("%20.2f", @OrderPrice).to_s + "');")                               
           WebView.execute_js("OrderedQty('" + @OrderedQty.to_s + "');")

           WebView.execute_js("SH('" + @TSDItembarcodes.ItemBarCode.to_s + "');") 
           WebView.execute_js("ENT_PR();")  
           ##redirect :action => :do_receipt             
         else
           if (flag == "2")                
               # Перейти на страницу ввода размера
               ##WebView.execute_js("TO_S();")  
               ##redirect :action => :inp_size                      
             else
               # Перейти на страницу ввода размера                
               ##WebView.execute_js("TO_I();")  
               ##render :action => :inp_item                             
           end            
         end                                  
                        
       end                    
    end           
  end
  
  # Ввод размера
  def input_size
    @@InventSizeId = @params["SIZE"]    
                
    @TsdReceiptjours = TsdReceiptjour.find( $TsdReceiptjourObj) 
    @@JourId = @TsdReceiptjours.JourId  
                      
     if (!@params["SIZE"])
#       Alert.show_popup(
#           :message=> "Введенного размера нет!",
#           :title=>"Ошибка",
#           :buttons => ["Ok"]
#        ) 
        $msg = "Введенного размера нет!"
        WebView.execute_js("alarm();") 
        WebView.execute_js("msg('" + $msg.to_s + "');")   
        WebView.execute_js("TO_I();")  
        ##render :action => :inp_item
     else      
       # Один ли в справочнике размеров
       if (@@InventSizeId != '')
       @TsdReceiptlines = TsdReceiptline.find(:first,
                :conditions => { 
                {
                :name => "ItemId", 
                :op => "IN" 
                } =>  @@ItemId,
                {
                :name => "InventSizeId", 
                :op => "IN" 
                } =>  @@InventSizeId,                  
                {
                :name => "JourId", 
                :op => "IN" 
                } => @@JourId                                                                    
                } )   
       else
         @TsdReceiptlines = TsdReceiptline.find(:first,
                  :conditions => { 
                  {
                  :name => "ItemId", 
                  :op => "IN" 
                  } =>  @@ItemId,                 
                  {
                  :name => "JourId", 
                  :op => "IN" 
                  } => @@JourId                                                                    
                  } )           
       end
                            

       if (!@TsdReceiptlines)
#         Alert.show_popup(
#             :message=> "Введенного размера (товара) нет в заказе!",
#             :title=>"Ошибка",
#             :buttons => ["Ok"]
#          ) 
          $msg = "Товара нет в заказе!"
          WebView.execute_js("alarm();") 
          WebView.execute_js("msg('" + $msg.to_s + "');")   
          WebView.execute_js("TO_I();")  
          ##render :action => :inp_item
       else  
         ##redirect :action => :do_receipt 
         _do_receipt        
         
         # Перейти на страницу приемки товара
         WebView.execute_js("ItemName('" + @ItemName.gsub(/["']/,"").to_s + "');")                 
         WebView.execute_js("ItemId('" + @ItemId.to_s + "');")  
         WebView.execute_js("InventSizeId('" + @InventSizeId.to_s + "');")  
         WebView.execute_js("VendCode('" + @VendCode.gsub(/["']/,"").to_s + "');")                                                                                                  
         WebView.execute_js("R_QTY('" + @ReceivedQty.to_s + "');")                                                         
         WebView.execute_js("OrderPrice('" + sprintf("%20.2f", @OrderPrice).to_s + "');")                               
         WebView.execute_js("OrderedQty('" + @OrderedQty.to_s + "');")
                   
         WebView.execute_js("TO_R();")         
       end
                
     end   
  end   
  
 # сканирование товара 
 def decode_item
   $msg = ""
   @@ItemId =  ""
   @@InventSizeId = ""
       
   @TsdReceiptjours = TsdReceiptjour.find( $TsdReceiptjourObj) 
   @@JourId = @TsdReceiptjours.JourId
     
     # Поиск записи в справочнике ШК
     @TSDItembarcodes = TsdItembarcode.find(:first,
              :conditions => { 
              {
              :name => "ItemBarCode", 
              :op => "IN" 
              } => @params["data"]         
             } )      
                                 
      if (!@TSDItembarcodes)
#        Alert.show_popup(
#            :message=> "ШК нет в справочнике!",
#            :title=>"Ошибка",
#            :buttons => ["Ok"]
#         ) 
         $msg = "ШК нет в справочнике!" 
        WebView.execute_js("alarm();")  
        WebView.execute_js("msgr('" + $msg.to_s + "');")  
        WebView.execute_js("SH('" + @params["data"].to_s + "');")  
        ##WebView.execute_js("TO_I();")   
        ## WebView.navigate(url_for(:action => :inp_item)) 
      else
        @@ItemId =  @TSDItembarcodes.ItemId
        @@InventSizeId = @TSDItembarcodes.InventSizeId
        
        # Один ли в справочнике размеров
        if (@@InventSizeId != '')
        @TsdReceiptlines = TsdReceiptline.find(:first,
                 :conditions => { 
                 {
                 :name => "ItemId", 
                 :op => "IN" 
                 } =>  @@ItemId,
                 {
                 :name => "InventSizeId", 
                 :op => "IN" 
                 } =>  @@InventSizeId,                  
                 {
                 :name => "JourId", 
                 :op => "IN" 
                 } => @@JourId                                                                    
                 } )   
        else
          @TsdReceiptlines = TsdReceiptline.find(:first,
                   :conditions => { 
                   {
                   :name => "ItemId", 
                   :op => "IN" 
                   } =>  @@ItemId,                 
                   {
                   :name => "JourId", 
                   :op => "IN" 
                   } => @@JourId                                                                    
                   } )           
        end              
 
        if (!@TsdReceiptlines)
#          Alert.show_popup(
#              :message=> "Введенного товара нет в заказе!",
#              :title=>"Ошибка",
#              :buttons => ["Ok"]
#           ) 
          $msg = "Товара нет в заказе!" 
          WebView.execute_js("alarm();")  
          WebView.execute_js("msgr('" + $msg.to_s + "');") 
          WebView.execute_js("SH('" + @params["data"].to_s + "');")   
          ##WebView.execute_js("TO_I();")   
          ##WebView.navigate(url_for(:action => :inp_item)) 
        else 
          _do_receipt
          
          # Перейти на страницу приемки товара
          WebView.execute_js("ItemName('" + @ItemName.gsub(/["']/,"").to_s + "');")                 
          WebView.execute_js("ItemId('" + @ItemId.to_s + "');")  
          WebView.execute_js("InventSizeId('" + @InventSizeId.to_s + "');")  
          WebView.execute_js("VendCode('" + @VendCode.gsub(/["']/,"").to_s + "');")                                                                                                  
          WebView.execute_js("R_QTY('" + @ReceivedQty.to_s + "');")                                                         
          WebView.execute_js("OrderPrice('" + sprintf("%20.2f", @OrderPrice).to_s + "');")                               
          WebView.execute_js("OrderedQty('" + @OrderedQty.to_s + "');")
          WebView.execute_js("SH('" + @params["data"].to_s + "');")  
                                       
           ##WebView.execute_js("TO_R();")
          WebView.execute_js("SH('" + @params["data"].to_s + "');")  
          
           $scan_code = @params["data"]         
             
           decode_line;
             
           ##WebView.navigate(url_for(:action => :do_receipt))           
        end
      end     
      
   WebView.execute_js("msgr('" + $msg.to_s + "');")       
 end 
  
 # Подготовка данных для показа формы приема товара
 def _do_receipt
   @ItemId = @@ItemId 
   @InventSizeId = @@InventSizeId
   @ItemName = ""
   @VendCode = "" 
   
   # Поиск строки в заказе
   if (@@InventSizeId != '')
   @TsdReceiptlines = TsdReceiptline.find(:first,
            :conditions => { 
            {
            :name => "ItemId", 
            :op => "IN" 
            } =>  @@ItemId,
            {
            :name => "InventSizeId", 
            :op => "IN" 
            } =>  @@InventSizeId,                  
            {
            :name => "JourId", 
            :op => "IN" 
            } => @@JourId                                                                    
            } )   
   else
     @TsdReceiptlines = TsdReceiptline.find(:first,
              :conditions => { 
              {
              :name => "ItemId", 
              :op => "IN" 
              } =>  @@ItemId,                 
              {
              :name => "JourId", 
              :op => "IN" 
              } => @@JourId                                                                    
              } )           
   end
              
   if (@TsdReceiptlines)    
     @OrderPrice = @TsdReceiptlines.OrderPrice
     @OrderedQty = @TsdReceiptlines.OrderedQty
     @ReceivedQty = @TsdReceiptlines.ReceivedQty      
   end         
#   Alert.show_popup(
#       :message=> @ReceivedQty,
#       :title=>"Ошибка",
#       :buttons => ["Ok"]
#    ) 
   
   # Поиск в справочнике товаров
   @TsdInventtables = TsdInventtable.find(:first,
            :conditions => { 
            {
            :name => "ItemId", 
            :op => "IN" 
            } =>  @@ItemId                           
            } )                                             
    
   if (@TsdInventtables)
     @ItemName = @TsdInventtables.ItemName
   end                  

   # Поиск в справочнике размеров и остатков
   if (@@InventSizeId != '')
   @TSDInventsums = TsdInventsum.find(:first,
            :conditions => { 
            {
            :name => "ItemId", 
            :op => "IN" 
            } =>  @@ItemId,
            {
              :name => "InventSizeId", 
              :op => "IN" 
            } =>  @@InventSizeId,
            {
              :name => "InventLocationId", 
              :op => "IN" 
            } =>  $chk_loc                                                                    
            } ) 
   else
     @TSDInventsums = TsdInventsum.find(:first,
              :conditions => { 
              {
              :name => "ItemId", 
              :op => "IN" 
              } =>  @@ItemId,
              {
                :name => "InventLocationId", 
                :op => "IN" 
              } =>  $chk_loc                                                                    
              } )      
   end                    
    
   if (@TSDInventsums)
     @VendCode = @TSDInventsums.VendCode
   end                  
         
#   if !System.get_property('is_emulator')
#     Scanner.disable
#     Scanner.decodeEvent = url_for(:action => :decode_line)
#     Scanner.enable
#   end 

   $TsdReceiptlineObj = @TsdReceiptlines.object        
   
   #render :action => :do_receipt       
 end
  
 # Нажатие на кнопку принять
 def receipt_by_button
   @@Scaner_Input = "0"
   @@ItemBarCode = "0"
   @@Input_count = @params["QTY"]
   flag = "0"
   begin
     tmp = @@Input_count.to_i 
   rescue 
     flag = "1" 
#     Alert.show_popup(
#         :message=> "Ошибка ввода!",
#         :title=>"Ошибка",
#         :buttons => ["Ok"]
#      ) 
     $msg = "Ошибка ввода!" 
     WebView.execute_js("alarm();") 
     WebView.execute_js("msg('" + $msg.to_s + "');")  
   end
   if (flag == "0")
     redirect :action => :get_po_checker
   else
     redirect :action => :do_receipt
   end
 end
 
 def listern_po_checker
   $in_cycle_check = @params['aj_po_ch'] 
 end
 
  def decode_line_2
    $msg = ""
    @@Scaner_Input = "1"
    @@ItemBarCode = @params["data"]
    #@@ItemBarCode = $scan_code
    #WebView.execute_js("read_po_checker();")     
    
    # Поиск признака разрешена ли перепоставка
    @TsdReceipjours = TsdReceiptjour.find($TsdReceiptjourObj) 
    @OverDelivery = @TsdReceipjours.OverDelivery           
    
    # Циклический режим приема заказа    
      if ( $in_cycle_check == "1")
      # Поиск записи в справочнике ШК
      @TSDItembarcodes = TsdItembarcode.find(:first,
               :conditions => { 
               {
               :name => "ItemBarCode", 
               :op => "IN" 
               } => @@ItemBarCode         
              } )      
                                  
       if (!@TSDItembarcodes)
 #        Alert.show_popup(
 #            :message=> "Товара нет в справочнике!",
 #            :title=>"Ошибка",
 #            :buttons => ["Ok"]
 #         ) 
          $msg = "Товара нет в справочнике!"
         WebView.execute_js("alarm();")  
         WebView.execute_js("msgr('" + $msg.to_s + "');") 
         WebView.execute_js("SH('" + @params["data"].to_s + "');")    
       else
         # Поиск строки в заказе
         @TsdReceiptlines = TsdReceiptline.find( $TsdReceiptlineObj)         
 
         if ((@TSDItembarcodes.ItemId == @TsdReceiptlines.ItemId) and 
             (@TSDItembarcodes.InventSizeId == @TsdReceiptlines.InventSizeId))
                         
            # Перепоставка запрещена а принятое кол-во равно запланированному
            if ((@OverDelivery == "0") and ( @TsdReceiptlines.ReceivedQty.to_i == @TsdReceiptlines.OrderedQty.to_i))
 #             Alert.show_popup(
 #                 :message=> "Превышение заказанного количества! Уже получено максимально возможное количество.",
 #                 :title=>"Ошибка",
 #                 :buttons => ["Ok"]
 #              ) 
               $msg = "Превышение кол-ва!"    
               WebView.execute_js("alarm();") 
               WebView.execute_js("msgr('" + $msg.to_s + "');")
               WebView.execute_js("SH('" + @params["data"].to_s + "');")             
            else
              @TsdReceiptlines.update_attributes({"ReceivedQty" => @TsdReceiptlines.ReceivedQty.to_i + 1})  
              @TsdReceipjours.update_attributes({"Importeds" => "0"})
              val =  @TsdReceiptlines.ReceivedQty.to_i  
              WebView.execute_js("set_r_qty('" + val.to_s + "');")                             
            end             
         else
 #          Alert.show_popup(
 #              :message=> "Неверный ШК текущей позиции!",
 #              :title=>"Ошибка",
 #              :buttons => ["Ok"]
 #           )  
 ##           $msg = "Неверный ШК!"    
 ##           WebView.execute_js("alarm();")   
 ##           WebView.execute_js("msgr('" + $msg.to_s + "');")  
               
 
 #           WebView.execute_js("set_sh_code(" + @@ItemBarCode.to_s + "," + '' + ");")                                          
 #           WebView.execute_js("inpitem();")                             
         end                
       end  
      end             
 
      WebView.execute_js("msgr('" + $msg.to_s + "');")                            
  end

 
 # Обработчик скана позиции в строке
 def decode_line
   $msg = ""
   @@Scaner_Input = "1"
   #@@ItemBarCode = @params["data"]
   @@ItemBarCode = $scan_code
   #WebView.execute_js("read_po_checker();")     
   
   # Поиск признака разрешена ли перепоставка
   @TsdReceipjours = TsdReceiptjour.find($TsdReceiptjourObj) 
   @OverDelivery = @TsdReceipjours.OverDelivery           
   
   # Циклический режим приема заказа    
     if ( $in_cycle_check == "1")
     # Поиск записи в справочнике ШК
     @TSDItembarcodes = TsdItembarcode.find(:first,
              :conditions => { 
              {
              :name => "ItemBarCode", 
              :op => "IN" 
              } => @@ItemBarCode         
             } )      
                                 
      if (!@TSDItembarcodes)
#        Alert.show_popup(
#            :message=> "Товара нет в справочнике!",
#            :title=>"Ошибка",
#            :buttons => ["Ok"]
#         ) 
         $msg = "Товара нет в справочнике!"
        WebView.execute_js("alarm();")  
        WebView.execute_js("msgr('" + $msg.to_s + "');")  
        WebView.execute_js("SH('" +  @@ItemBarCode.to_s + "');")   
      else
        # Поиск строки в заказе
        @TsdReceiptlines = TsdReceiptline.find( $TsdReceiptlineObj)         

        if ((@TSDItembarcodes.ItemId == @TsdReceiptlines.ItemId) and 
            (@TSDItembarcodes.InventSizeId == @TsdReceiptlines.InventSizeId))
                        
           # Перепоставка запрещена а принятое кол-во равно запланированному
           if ((@OverDelivery == "0") and ( @TsdReceiptlines.ReceivedQty.to_i == @TsdReceiptlines.OrderedQty.to_i))
#             Alert.show_popup(
#                 :message=> "Превышение заказанного количества! Уже получено максимально возможное количество.",
#                 :title=>"Ошибка",
#                 :buttons => ["Ok"]
#              ) 
              $msg = "Превышение кол-ва!"    
              WebView.execute_js("alarm();") 
              WebView.execute_js("msgr('" + $msg.to_s + "');") 
             WebView.execute_js("QTY('" +  '' + "');")             
           else
             @TsdReceiptlines.update_attributes({"ReceivedQty" => @TsdReceiptlines.ReceivedQty.to_i + 1})  
             @TsdReceipjours.update_attributes({"Importeds" => "0"})
             val =  @TsdReceiptlines.ReceivedQty.to_i  
             WebView.execute_js("set_r_qty('" + val.to_s + "');")                              
           end             
        else
#          Alert.show_popup(
#              :message=> "Неверный ШК текущей позиции!",
#              :title=>"Ошибка",
#              :buttons => ["Ok"]
#           )  
##           $msg = "Неверный ШК!"    
##           WebView.execute_js("alarm();")   
##           WebView.execute_js("msgr('" + $msg.to_s + "');")  
              

#           WebView.execute_js("set_sh_code(" + @@ItemBarCode.to_s + "," + '' + ");")                                          
#           WebView.execute_js("inpitem();")                             
        end                
      end  
     else
#                 Alert.show_popup(
#                     :message=> "Jo",
#                     :title=>"Ошибка",
#                     :buttons => ["Ok"]
#                  ) 
       
       WebView.execute_js("QTY('" +  '' + "');")         
     end             

     WebView.execute_js("msgr('" + $msg.to_s + "');")                            
 end
 
 # Возвратить выбранный режим работы
 def get_po_checker
   $msg = ""
   #cycle_input = @params['aj_po_ch']       
   cycle_input = $in_cycle_check  
     
   # Поиск признака разрешена ли перепоставка
   @TsdReceipjours = TsdReceiptjour.find($TsdReceiptjourObj) 
   @OverDelivery = @TsdReceipjours.OverDelivery           
   
   # Циклический режим приема заказа  
   if (cycle_input == "1")      
     if ( @@ItemBarCode != "0")
     # Поиск записи в справочнике ШК
     @TSDItembarcodes = TsdItembarcode.find(:first,
              :conditions => { 
              {
              :name => "ItemBarCode", 
              :op => "IN" 
              } => @@ItemBarCode         
             } )      
                                 
      if (!@TSDItembarcodes)
#        Alert.show_popup(
#            :message=> "Товара нет в справочнике!",
#            :title=>"Ошибка",
#            :buttons => ["Ok"]
#         ) 
         $msg = "Товара нет в справочнике!"
         WebView.execute_js("alarm();") 
         WebView.execute_js("msgr('" + $msg.to_s + "');")  
      else
        # Поиск строки в заказе
        @TsdReceiptlines = TsdReceiptline.find( $TsdReceiptlineObj)         

        if ((@TSDItembarcodes.ItemId == @TsdReceiptlines.ItemId) and 
            (@TSDItembarcodes.InventSizeId == @TsdReceiptlines.InventSizeId))
                        
           # Перепоставка запрещена а принятое кол-во равно запланированному
           if ((@OverDelivery == "0") and ( @TsdReceiptlines.ReceivedQty.to_i == @TsdReceiptlines.OrderedQty.to_i))
#             Alert.show_popup(
#                 :message=> "Превышение заказанного количества! Уже получено максимально возможное количество.",
#                 :title=>"Ошибка",
#                 :buttons => ["Ok"]
#              )  
              $msg =  "Превышение кол-ва!"  
              WebView.execute_js("alarm();")  
              WebView.execute_js("msgr('" + $msg.to_s + "');")            
           else
             @TsdReceiptlines.update_attributes({"ReceivedQty" => @TsdReceiptlines.ReceivedQty.to_i + 1})  
             @TsdReceipjours.update_attributes({"Importeds" => "0"})                          
           end             
        else
#          Alert.show_popup(
#              :message=> "Неверный ШК текущей позиции!",
#              :title=>"Ошибка",
#              :buttons => ["Ok"]
#           )
           $msg = "Неверный ШК!"
           WebView.execute_js("alarm();")   
           WebView.execute_js("msgr('" + $msg.to_s + "');")              
        end                
      end  
     end             
   else
   # Не цикличекский ввод
     # Поиск строки в заказе
     @TsdReceiptlines = TsdReceiptline.find( $TsdReceiptlineObj)       
     
     # Перепоставка запрещена а принятое кол-во больше запланированного
     if ((@OverDelivery == "0") and ( @TsdReceiptlines.ReceivedQty.to_i + @@Input_count.to_i > @TsdReceiptlines.OrderedQty.to_i ))
#       Alert.show_popup(
#           :message=> "Превышение заказанного количества! Уже получено максимально возможное количество.",
#           :title=>"Ошибка",
#           :buttons => ["Ok"]
#        )  
        $msg = "Превышение кол-ва!" 
       WebView.execute_js("alarm();") 
       WebView.execute_js("msgr('" + $msg.to_s + "');")  
       WebView.execute_js("nulling();")               
     else
       if (@TsdReceiptlines.ReceivedQty.to_i + @@Input_count.to_i < 0)
#         Alert.show_popup(
#             :message=> "Принятое кол-во не может быть отрицательным! Попробуйте ещё раз...",
#             :title=>"Ошибка",
#             :buttons => ["Ok"]
#          ) 
         $msg = "Принятое кол-во отриц.!" 
         WebView.execute_js("alarm();") 
         WebView.execute_js("msgr('" + $msg.to_s + "');")  
         WebView.execute_js("nulling();")   
       else
         @TsdReceiptlines.update_attributes({"ReceivedQty" => @TsdReceiptlines.ReceivedQty.to_i + @@Input_count.to_i}) 
         @TsdReceipjours.update_attributes({"Importeds" => "0"})
         val =  @TsdReceiptlines.ReceivedQty.to_i  
         WebView.execute_js("set_r_qty('" + val.to_s + "');")                     
       end                        
     end             
   end  
  
   if (@@Scaner_Input == "1")
     WebView.navigate(url_for(:action => :do_receipt))  
#   else 
#     redirect :action => :do_receipt         
   end
   
   WebView.execute_js("msgr('" + $msg.to_s + "');") 
 end
 

 # Завершение приемки
 def end_receipt 
   redirect :action => :do_receipt
 end
  
 # смена режима приемки
 def change_rejim
   $in_cycle_check = @params["val"]     
 end
 
 # Обработчик нажатия кнопки
 def rec_button
   $msg = ""
   @@Scaner_Input = "0"
   @@ItemBarCode = "0"
   @@Input_count = @params["val"]
   flag = "0"
   begin
     tmp = @@Input_count.to_i 
   rescue 
     flag = "1" 
#     Alert.show_popup(
#         :message=> "Ошибка ввода!",
#         :title=>"Ошибка",
#         :buttons => ["Ok"]
#      ) 
      $msg = "Ошибка ввода!"
      WebView.execute_js("alarm();") 
      WebView.execute_js("msgr('" + $msg.to_s + "');")  
   end
   if (flag == "0")
     cycle_input = $po_cycle_check  
       
     # Поиск признака разрешена ли перепоставка
     @TsdReceipjours = TsdReceiptjour.find($TsdReceiptjourObj) 
     @OverDelivery = @TsdReceipjours.OverDelivery           
     
     # Циклический режим приема заказа  
     if (cycle_input == "1")      
       if ( @@ItemBarCode != "0")
       # Поиск записи в справочнике ШК
       @TSDItembarcodes = TsdItembarcode.find(:first,
                :conditions => { 
                {
                :name => "ItemBarCode", 
                :op => "IN" 
                } => @@ItemBarCode         
               } )      
                                   
        if (!@TSDItembarcodes)
#          Alert.show_popup(
#              :message=> "Товара нет в справочнике!",
#              :title=>"Ошибка",
#              :buttons => ["Ok"]
#           ) 
           $msg = "Товара нет в справочнике!"
           WebView.execute_js("alarm();") 
           WebView.execute_js("msgr('" + $msg.to_s + "');")  
        else
          # Поиск строки в заказе
          @TsdReceiptlines = TsdReceiptline.find( $TsdReceiptlineObj)         
  
          if ((@TSDItembarcodes.ItemId == @TsdReceiptlines.ItemId) and 
              (@TSDItembarcodes.InventSizeId == @TsdReceiptlines.InventSizeId))
                          
             # Перепоставка запрещена а принятое кол-во равно запланированному
             if ((@OverDelivery == "0") and ( @TsdReceiptlines.ReceivedQty.to_i == @TsdReceiptlines.OrderedQty.to_i))
#               Alert.show_popup(
#                   :message=> "Превышение заказанного количества! Уже получено максимально возможное количество.",
#                   :title=>"Ошибка",
#                   :buttons => ["Ok"]
#                ) 
                $msg = "Превышение кол-ва!" 
               WebView.execute_js("alarm();") 
               WebView.execute_js("msgr('" + $msg.to_s + "');")                
             else
               @TsdReceiptlines.update_attributes({"ReceivedQty" => @TsdReceiptlines.ReceivedQty.to_i + 1})  
               @TsdReceipjours.update_attributes({"Importeds" => "0"})                          
             end             
          else
#            Alert.show_popup(
#                :message=> "Неверный ШК текущей позиции!",
#                :title=>"Ошибка",
#                :buttons => ["Ok"]
#             ) 
##             $msg = "Неверный ШК!"  
##             WebView.execute_js("alarm();")  
##             WebView.execute_js("msgr('" + $msg.to_s + "');")  
             
             line_edit;       
          end                
        end  
       end             
     else
     # Не цикличекский ввод
       # Поиск строки в заказе
       @TsdReceiptlines = TsdReceiptline.find( $TsdReceiptlineObj)       
       
       # Перепоставка запрещена а принятое кол-во больше запланированного
       if ((@OverDelivery == "0") and ( @TsdReceiptlines.ReceivedQty.to_i + @@Input_count.to_i > @TsdReceiptlines.OrderedQty.to_i ))
#         Alert.show_popup(
#             :message=> "Превышение заказанного количества! Уже получено максимально возможное количество.",
#             :title=>"Ошибка",
#             :buttons => ["Ok"]
#          )    
          $msg = "Превышение кол-ва!"
          WebView.execute_js("alarm();") 
          WebView.execute_js("msgr('" + $msg.to_s + "');")  
          WebView.execute_js("nulling();")              
       else
         if (@TsdReceiptlines.ReceivedQty.to_i + @@Input_count.to_i < 0)
#           Alert.show_popup(
#               :message=> "Принятое кол-во не может быть отрицательным! Попробуйте ещё раз...",
#               :title=>"Ошибка",
#               :buttons => ["Ok"]
#            ) 
            $msg = "Принятое кол-во не отриц.!"
           WebView.execute_js("alarm();") 
           WebView.execute_js("msgr('" + $msg.to_s + "');")  
           WebView.execute_js("nulling();")   
         else
           @TsdReceiptlines.update_attributes({"ReceivedQty" => @TsdReceiptlines.ReceivedQty.to_i + @@Input_count.to_i}) 
           @TsdReceipjours.update_attributes({"Importeds" => "0"})
           val =  @TsdReceiptlines.ReceivedQty.to_i  
           WebView.execute_js("set_r_qty('" + val.to_s + "');")  
           WebView.execute_js("form_focus();")                    
         end                        
       end             
     end               
   end   
     
   WebView.execute_js("msgr('" + $msg.to_s + "');")   
 end
 
 def back_to_detail
   $msg = ""
   if !System.get_property('is_emulator') 
     Scanner.disable
   end  
   
   redirect :action => :show_detail, :id => $TsdReceiptjourObj
 end
 
  def back_to_detail_2
     $msg = ""
     if !System.get_property('is_emulator') 
       Scanner.disable
     end  
     
     WebView.navigate(url_for(:action => :show_detail, :id => $TsdReceiptjourObj)) 
     #redirect :action => :show_detail, :id => $TsdReceiptjourObj
   end
   
 
end

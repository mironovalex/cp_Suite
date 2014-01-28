require 'rho/rhocontroller'
require 'helpers/browser_helper'

class InventController < Rho::RhoController
  include BrowserHelper
  
  def login_callback
    if rho_error.unknown_client?( @params['error_message'] )
      Rhom::Rhom.database_client_reset
    end  
  end 
  
  def invent_menu_
    $DateOrder = @params['DAT']
    ##WebView.navigate(url_for(:action => :invent_menu)) 
    WebView.navigate(url_for(:action => :show_invent_)) 
  end
  
  def show_invent_
    $msg = ""
    $msg1 = ""
    $msg2 = ""
    
    WebView.execute_js("nulling();") 
    
    redirect :action => :show_invent
  end  
  
  def show_invent_2
    $msg = ""
    $msg1 = ""
    $msg2 = ""
    
    WebView.execute_js("nulling();") 
        
    WebView.navigate(url_for(:action => :show_invent))
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
  end   
   
  # Считывание даты заказов
  def invent_menu 
    render :action => :invent_menu
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
    
    WebView.execute_js("nulling();")     
        
    load_Items_1  
  end
  
  def load_Items_1
    $sync_msg = "Загрузка: ШК Инв." 
    redirect :controller => :Settings, :action => :wait   
    if !(SyncEngine::logged_in > 0)
      SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
    end 
    $sync_control = "31"
    @accts = TsdItembarcodetemp.find_by_sql("DELETE FROM TsdItembarcodetemp")         
    
#          Alert.show_popup(
#              :message=>  "TsdItembarcodetemp |" + $Itembarcode_synccount.to_s,
#              :title=>"Ошибка",
#              :buttons => ["Ok"]
#           )      
    
    SyncEngine.dosync_source(TsdItembarcodetemp, true, 
      "query[param]=" + $chk_loc.to_s + "&query[param2]=" + $Itembarcode_synccount.to_s + "&query[param3]=2" )
  end
  
  def load_Items_2 
    $sync_msg = "Загрузка: Товары Инв." 
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
      $sync_control = "41"
      @accts = TsdInventtabletmp.find_by_sql("DELETE FROM TsdInventtabletmp")            
      
#      Alert.show_popup(
#          :message=>  "TsdInventtabletmp |" + $Inventtable_synccount.to_s,
#          :title=>"Ошибка",
#          :buttons => ["Ok"]
#       ) 
      $sync_msg = "Загрузка: Товары Инв." 
              
      SyncEngine.dosync_source(TsdInventtabletmp, true, 
        "query[param]=" + $chk_loc.to_s + "&query[param2]=" + $Inventtable_synccount.to_s + "&query[param3]=2" )        
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
      $sync_control = "51"  
      @accts = TsdInventsumtmp.find_by_sql("DELETE FROM TsdInventsumtmp")    
      
#      Alert.show_popup(
#          :message=>  "TsdInventsumtmp |" + $Inventsum_synccount.to_s,
#          :title=>"Ошибка",
#          :buttons => ["Ok"]
#       ) 
          
      SyncEngine.dosync_source(TsdInventsumtmp, true, 
        "query[param]=" + $chk_loc.to_s + "&query[param2]=" + $Inventsum_synccount.to_s + "&query[param3]=2" )        
    end          
  end
  
  def load_Items_4
    $sync_msg = "Загрузка: Цены Инв." 
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
      $sync_control = "601" 
      @accts = TsdInventpricetmp.find_by_sql("DELETE FROM TsdInventpricetmp")  

#      Alert.show_popup(
#          :message=>  "TsdInventpricetmp |" + $Inventprice_synccount.to_s,
#          :title=>"Ошибка",
#          :buttons => ["Ok"]
#       ) 

      $sync_msg = "Загрузка: Цены Инв." 
      
      SyncEngine.dosync_source(TsdInventpricetmp, true, 
        "query[param]=" + $chk_loc.to_s + "&query[param2]=" + $Inventprice_synccount.to_s + "&query[param3]=2") 
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
        #WebView.navigate( url_for :controller => :Invent, :action => :dnload_invents ) 
        dnload_invents           
    end   
  end
  
 ######################################################################################   
  
    def dnload_invent_2 
    $sync_msg = "Загрузка: Инв. строки" 
    redirect :controller => :Settings, :action => :wait  
    $sync_control = "16"

    if !(SyncEngine::logged_in > 0)
      SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
    end 
      SyncEngine.dosync_source( TsdInventcountlineselect, show_sync_status = true, "query[param1]=" + $chk_loc.to_s + "&query[param2]=" + $DateOrder.to_s )           
  end
  
    def dnload_invent_3                                                                                                   
    @TsdInventcountjourselects = TsdInventcountjourselect.find(:all)
    
    @TsdInventcountjourselects.each do |jour|     
      jour.update_attributes({"Mark" => "0"})
    end
                  
    dnl_inv_one              
  end
  
  def upload_invent_01
    # Найти все заказы
    @TsdInventcountjours = TsdInventcountjour.find(:all,
    :conditions => { 
      {
        :name => "InventLocationId", 
        :op => "IN" 
      } => $chk_loc                 
      } )
      
    @TsdInventcountjours.each do |jour|     
      jour.update_attributes({"Mark" => "0"})  
    end  

    upload_invent_02    
  end
  
  def upload_invent_02
    # Найти все не обработанные заказы
    @TsdInventcountjours = TsdInventcountjour.find(:first,
    :conditions => { 
      {
        :name => "InventLocationId", 
        :op => "IN" 
      } => $chk_loc,
      {
        :name => "Mark", 
        :op => "IN" 
      } => "0"                        
      } )  
      
   if (@TsdInventcountjours)
     @TsdInventcountjourselects = TsdInventcountjourselect.find(:first,
     :conditions => { 
       {
         :name => "JourId", 
         :op => "IN" 
       } => @TsdInventcountjours.JourId                  
       } )      
     
     # Заказа нет в хосте  
     if (!@TsdInventcountjourselects)
       @TsdInventcountlinesselects = TsdInventcountlineselect.find(:all,
       :conditions => { 
         {
           :name => "JourId", 
           :op => "IN" 
         } => @TsdInventcountjours.JourId                  
         } )        
       
      count = "0"   
       @TsdInventcountlinesselects.each do |row|
         count = count.to_i + row.CountedQty.to_i
       end   
      
       # По заказу нет принятых позиций
       if (count == "0")
         j = @TsdInventcountjours.JourId
         TsdInventcountline.delete_all(:conditions => {'JourId'=> j })
         TsdInventcountjour.delete_all(:conditions => {'JourId'=> j })  
         upload_invent_02 
       else
         $JourId =  @TsdInventcountjours.JourId 
         
         Alert.show_popup(
           :message=> "Журнала " + @TsdInventcountjours.JourId.to_s + " нет в хост системе, но он отработан. Удалить журнал?",
           :title=>"Внимание",
           :buttons => ["ДА", "HET"],
           :callback => url_for(:action => :on_update_invent_01)
           )            
                                             
       end
                                        
     else 
       @TsdInventcountjours.update_attributes({"Mark" => "1"})  
       upload_invent_02   
     end
                               
   else
     if ($msg = "")        
       $msg1 = "Синхронизация выполненна"
       $msg2 = ""  
       status = "0" 
     else
       $msg1 = "" 
       $msg2 = $msg
       status = "1"                   
     end  
     
     # Синхронизация завершена
     # Запись в лог    
     t = Time.now        
     
     count0 = TsdInventcountjour.find(:count) 
     count1 = TsdInventcountline.find(:count) 
     
     TsdLog.create("UserId" => $chk_userid, 
                   "InventLocationId" => $chk_loc,
                   "DeviceID" => $device_id,
                   "Date" => t.strftime("%Y-%m-%d"),
                   "Time" => t.strftime("%S").to_i + t.strftime("%M").to_i*60 + t.strftime("%H").to_i*3600,
                   "Operation" => "10",
                   "Status" =>  status,                      
                   "Comment" => "TsdInventcountjours: " + count0.to_s + " строк | " +
                                "TsdInventcountline: " + count1.to_s + " строк")        
     
       if ($sync_err == "0")
#         Alert.show_popup(
#             :message=> "Синхронизация успешно выполнена",
#             :title=>"Сообщение",
#             :buttons => ["Ok"]
#          ) 
          
         $sync_control == "-1"  
       end          
            
       ##WebView.navigate(url_for :controller => :Invent, :action => :invent_menu) 
       WebView.navigate(url_for :controller => :Invent, :action => :show_invent)           
   end   
              
  end

  
  def on_update_invent_01
         
    jour = TsdInventcountjour.find(:first, 
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
      TsdInventcountline.delete_all(:conditions => {'JourId'=> j })
      TsdInventcountjour.delete_all(:conditions => {'JourId'=> j })  
    end
        
    upload_invent_02
  end   
  
  
  
  
  
  
  
  
  
  
  
  
  # Загрузка данных
  def dnload_invents
    $sync_msg = "Загрузка: Инв."           
    redirect :controller => :Settings, :action => :wait
    #Загрузка заказов
    TsdInventcountjourselect.delete_all()
    TsdInventcountlineselect.delete_all()
    
    $sync_err = "0"
    $sync_err_msg = ""   
    
    $sync_control = "15"
       
    if !(SyncEngine::logged_in > 0)
      SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
    end 
      SyncEngine.dosync_source(TsdInventcountjourselect, show_sync_status = true, "query[param1]=" + $chk_loc.to_s + "&query[param2]=" + $DateOrder.to_s )   
  
    #render :action => :invent_menu
  end

    def dnl_inv_one
    # Обработка загрузки              
    @TsdInventcountjourselects = TsdInventcountjourselect.find(:first,      
      :conditions => { 
    {
      :name => "Mark", 
      :op => "IN" 
    } => "0"         
    } )
    
    # Новых заказов нет
    if (!@TsdInventcountjourselects)
      #-----------------------------------------------------------------   
#      @Tsd = TsdInventcountjour.find(:all)      
#      
#      @Tsd.each do |rec|
#        Alert.show_popup(
#            :message=> rec,
#            :title=>"Ошибка",
#            :buttons => ["Ok"]
#         )         
#      end
      
#    # Запись в лог    
#    t = Time.now        
#    
#    TsdLog.create("UserId" => $chk_userid, 
#                  "InventLocationId" => $chk_loc,
#                  "DeviceID" => $device_id,
#                  "Date" => t.strftime("%Y-%m-%d"),
#                  "Time" => t.strftime("%S").to_i + t.strftime("%M").to_i*60 + t.strftime("%H").to_i*3600,
#                  "Operation" => "7",
#                  "Status" =>  $sync_err,                      
#                  "Comment" => $sync_err_msg.to_s)        
#	  
#      if ($sync_err == "0")
#        Alert.show_popup(
#            :message=> "Синхронизация успешно выполнена",
#            :title=>"Сообщение",
#            :buttons => ["Ok"]
#         ) 
         
#        $sync_control == "-1"  
#      end 
      
      #--------------------------------------------------------------------------------------------------------  
      #WebView.navigate(url_for :controller => :Invent, :action => :invent_menu)  
      
      upload_invent_01                             
    
    else
       jour = @TsdInventcountjourselects                    
      
      @TsdInventcountjours = TsdInventcountjour.find(:first,
      :conditions => { 
        {
          :name => "JourId", 
          :op => "IN" 
        } => jour.JourId         
        } )
              
      @TsdInventcountlines = TsdInventcountline.find(:all,
      :conditions => { 
        {
          :name => "JourId", 
          :op => "IN" 
        } => jour.JourId         
        } )
        
      count = "0"  
        
      @TsdInventcountlines.each do |row|
        count = count.to_i + row.CountedQty.to_i
      end          
              
	  # Если заказ непринят  
      if (count.to_i == 0)
        jour.update_attributes({"Mark" => "1"})
       
        # Удалить заказ
        TsdInventcountjour.delete_all(:conditions => {'JourId'=> jour.JourId })                    
          
       # скопировать запись в БД
             TsdInventcountjour.create("JourId" => jour.JourId, 
               "InventLocationId" => jour.InventLocationId, 		   
               "JourDescription"   => jour.JourDescription, 
               "JourDate" => jour.JourDate, #$DateOrder
               "Deleted" => jour.Deleted,
               "Imported" => jour.Imported,
               "Importeds" => "0"             
               )        
 
      # Удалить все строки по заказу
      TsdInventcountline.delete_all(:conditions => {'JourId'=> jour.JourId })
        
      @TsdInventcountlineselects = TsdInventcountlineselect.find(:all, 
        :conditions => { 
          {
            :name => "JourId", 
            :op => "IN" 
          } => jour.JourId         
          } )        
      
      @TsdInventcountlineselects.each do |line|
        TsdInventcountline.create("JourId" => line.JourId, 
          "ItemId" => line.ItemId, 
          "InventSizeId"   => line.InventSizeId, 
          "ItemBarCode" => line.ItemBarCode,
          "CountedQty" => "0"
          )           
       end 

       dnl_inv_one	   
      else	 
	   # Если заказ уже есть в БД   
	   if (@TsdInventcountjours)
       #--------------------------------------------------------------------------    
       flag ="0"
       
       @TsdInventcountjourselects = TsdInventcountjourselect.find(:first,
       :conditions => { 
         {
           :name => "JourId", 
           :op => "IN" 
         } => jour.JourId         
         } )        

       if (@TsdInventcountjourselects.JourDescription != @TsdInventcountjours.JourDescription)
         flag = "1"
       end  

       if (@TsdInventcountjourselects.JourDate != @TsdInventcountjours.JourDate)
         flag = "1"
       end 
                      
       @TsdInventcountlines = TsdInventcountline.find(:all,
       :conditions => { 
         {
           :name => "JourId", 
           :op => "IN" 
         } => jour.JourId         
         } )       
       
       @TsdInventcountlineselects = TsdInventcountlineselect.find(:all,
       :conditions => { 
         {
           :name => "JourId", 
           :op => "IN" 
         } => jour.JourId         
         } )  
         
		 count1 = "0"
         @TsdInventcountlines.each do |row|
#           Alert.show_popup(
#               :message=> row.ItemId.to_s.bytes.to_a,
#               :title=>"Ошибка",
#               :buttons => ["Ok"]
#            ) 
            count1 = count1.to_i + row.CountedQty.to_i #+ row.ItemId.bytes.to_a.inject(0){ |result, elem| result + elem }.to_i + row.InventSizeId.bytes.to_a.inject(0){ |result, elem| result + elem }.to_i
         end  

		 count2 = "0"
         @TsdInventcountlineselects.each do |row|
            count2 = count2.to_i + row.CountedQty.to_i #+ row.ItemId.bytes.to_a.inject(0){ |result, elem| result + elem }.to_i + row.InventSizeId.bytes.to_a.inject(0){ |result, elem| result + elem }.to_i
         end 
		 
         if (count1 != count2)
           flag = "1"
         end   
         
       $JourId = jour.JourId     

       if ( flag == "1")       
         Alert.show_popup(
           :message=> "Журнал " + jour.JourId.to_s + " был изменен. Перезагрузить?",
           :title=>"Внимание",
           :buttons => ["ДА", "HET"],
           :callback => url_for(:action => :on_update_invent)
           )  
        else
          jour.update_attributes({"Mark" => "1"})
		      dnl_inv_one
        end
		
     else
       jour.update_attributes({"Mark" => "1"})
       
       # скопировать запись в БД
             TsdInventcountjour.create("JourId" => jour.JourId, 
               "InventLocationId" => jour.InventLocationId, 
               "JourDescription"   => jour.JourDescription, 
               "JourDate" => jour.JourDate, #$DateOrder
               "Deleted" => jour.Deleted,
               "Imported" => jour.Imported,
               "Importeds" => "0"                
               )        
 
      # Удалить все строки по заказу
      TsdReceiptline.delete_all(:conditions => {'JourId'=> jour.JourId })
        
      @TsdInventcountlineselects = TsdInventcountlineselect.find(:all, 
        :conditions => { 
          {
            :name => "JourId", 
            :op => "IN" 
          } => jour.JourId         
          } )        
      
      @TsdInventcountlineselects.each do |line|
        TsdInventcountline.create("JourId" => line.JourId, 
          "ItemId" => line.ItemId, 
          "InventSizeId"   => line.InventSizeId, 
          "ItemBarCode" => line.ItemBarCode,
          "CountedQty" => "0"
          )           
       end 
       dnl_inv_one		   
     end       
     end
	  
    end
    
  end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  def on_update_invent
         
    jour = TsdInventcountjourselect.find(:first, 
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
      TsdInventcountjour.delete_all(:conditions => {'JourId'=> jour.JourId })        
        
      # скопировать запись в БД
            TsdInventcountjour.create("JourId" => jour.JourId, 
              "InventLocationId" => jour.InventLocationId, 
              "JourDescription" => jour.JourDescription,
              "JourDate" => jour.JourDate, #$DateOrder
              "Deleted" => jour.Deleted,
              "Imported" => jour.Imported,
              "Importeds" => "0"                
              )        
                          
    # Удалить все строки по заказу               
    TsdInventcountline.delete_all(:conditions => {'JourId'=> jour.JourId }) 
 
     @TsdInventcountlineselects = TsdInventcountlineselect.find(:all, 
       :conditions => { 
         {
           :name => "JourId", 
           :op => "IN" 
         } => jour.JourId         
         } )        
     
     @TsdInventcountlineselects.each do |line|
       TsdInventcountline.create("JourId" => line.JourId, 
         "ItemId" => line.ItemId, 
         "InventSizeId"   => line.InventSizeId, 
         "ItemBarCode" => line.ItemBarCode,
         "CountedQty" => "0"
         )           
      end       
    end
        
    dnl_inv_one
  end  

  
  
  #---------------------------------------------------------------------------------
  
#  # Подготовка к показу шапки заказа
  def show_detail   
    @TsdInventcountjours = TsdInventcountjour.find(@params['id'])          
    $TsdInventcountjourObj = @params['id']  
      
    @JourId =  ""
   
    @JourDescription =   "" 
    @JourDate = ""   
    
    @InventQty  = "0"
    
    @IsInvented = "0"
    @Imported   = "0"               
    
    if (@TsdInventcountjours)
      @JourId =  @TsdInventcountjours.JourId
      
       @JourDescription =   @TsdInventcountjours.JourDescription 
       @JourDate = @TsdInventcountjours.JourDate   
       
       @Imported = @TsdInventcountjours.Importeds
     end        
     
    # Расчет принятого и планового кол-ва
    @TsdInventcountlines = TsdInventcountline.find(:all,
             :conditions => { 
             {
             :name => "JourId", 
             :op => "IN" 
             } => @JourId        
            } )      
                                
     if (@TsdInventcountlines)
       @TsdInventcountlines.each do |invent|             
         @InventQty = @InventQty.to_i + invent.CountedQty.to_i
       end              
     end
     
    if (@InventQty.to_i == 0)
      @IsInvented = "Нет"
    else
      @IsInvented = "Да"         
    end  

    if (@Imported == "0")
      @Imported = "Нет"
    else
      @Imported = "Да"         
    end  
     
    render :action => :show_detail       
  end

  # Запрос на обнуление заказа
  def null_invent
    $msg = ""
    $msg1 = ""
    $msg2 = ""
    
    WebView.execute_js("nulling();") 
    
    @TsdInventcountjours = TsdInventcountjour.find( $TsdInventcountjourObj)     

    Alert.show_popup(
        :message=> "Журнал " + @TsdInventcountjours.JourId + " будет обнулен. Продолжить?",
        :title=>"Внимание",
        :buttons => ["ДА", "HET"],
        :callback => url_for(:action => :on_null_invent_check)
        )         
  end  
  
  # Обнуление заказа
  def on_null_invent_check 
    if (@params['button_id'] == 'HET')
      WebView.navigate(url_for(:action => :show_detail, :id => $TsdInventcountjourObj)) 
    else
      @TsdInventcountjours = TsdInventcountjour.find( $TsdInventcountjourObj)    
      @TsdInventcountlines = TsdInventcountline.find(:all,
      :conditions => { 
        {
          :name => "JourId", 
          :op => "IN" 
        } => @TsdInventcountjours.JourId                                 
      })       
      
      @TsdInventcountlines.each do |line|
        line.update_attributes({"CountedQty" => "0"}) 
      end
      
      @TsdInventcountjours.update_attributes({"Importeds" => "0"})   
      
      WebView.navigate(url_for(:action => :show_detail, :id => $TsdInventcountjourObj))                
    end
    
  end  
  
  #----------------------------------------------------------------------------------------------
  
   def upload_invent_2
     $sync_msg = "Выгрузка: Запрос Инв. строки" 
   redirect :controller => :Settings, :action => :wait
	 if !(SyncEngine::logged_in > 0)
       SyncEngine.login("1", "1", (url_for :action => :login_callback) )
     end
      $sync_control = "18"
      SyncEngine.dosync_source( TsdInventcountlineselect, show_sync_status = true, "query[param1]=" + $JourId.to_s )
	  
	 #render :action => :show_detail, :id => $TsdInventcountjourObj
	end 
  
   def upload_invent_3 
     $sync_msg = "Выгрузка: Инв." 
     redirect :controller => :Settings, :action => :wait
    @TsdInventcountjours = TsdInventcountjour.find( $TsdInventcountjourObj) 
    @TsdInventcountlines = TsdInventcountline.find(:all,
      :conditions => { 
        {
          :name => "JourId", 
          :op => "IN" 
        } => @TsdInventcountjours.JourId                                 
      }) 
	
    @TsdInventcountlineselects = TsdInventcountlineselect.find(:all,
      :conditions => { 
        {
          :name => "JourId", 
          :op => "IN" 
        } => @TsdInventcountjours.JourId                                 
      }) 		  

     @TsdInventcountjourselects = TsdInventcountjourselect.find(:first,
       :conditions => { 
         {
           :name => "JourId", 
           :op => "IN" 
         } => @TsdInventcountjours.JourId                                 
       })        
      	
	count = "0"
#	@TsdInventcountlineselects.each do |row|
#	  count = count.to_i + row.CountedQty.to_i
#	end 
	
	
#         Alert.show_popup(
#             :message=> @TsdInventcountjourselects,
#             :title=>"Сообщение",
#             :buttons => ["Ok"]
#          ) 	
      
	if (@TsdInventcountjourselects.Imported == "1")
	  count = "1"
	end
	
	# ранее выгружен
	if (count.to_i > 0)
	    Alert.show_popup(
           :message=> "Инвентаризация " + $JourId.to_s + " уже была выполнена и выгружена. Перевыгрузить?",
           :title=>"Внимание",
           :buttons => ["ДА", "HET"],
           :callback => url_for(:action => :upload_invent_6)
           ) 
	else
	# Перезапись
	TsdInventcountjourtmp.delete_all();
	TsdInventcountlinetmp.delete_all();
	
	TsdInventcountjourtmp.create("JourId" =>  @TsdInventcountjours.JourId.to_s, 
        "InventLocationId" => @TsdInventcountjours.InventLocationId.to_s, 
        "JourDescription"   => @TsdInventcountjours.JourDescription.to_s, 
        "JourDate" => @TsdInventcountjours.JourDate.to_s,
        "Deleted" => @TsdInventcountjours.Deleted.to_s,
        "Imported" => "1"          
        )

	@TsdInventcountlines.each do |row|
#    Alert.show_popup(
#        :message=> row,
#        :title=>"Ошибка",
#        :buttons => ["Ok"]
#     ) 
      TsdInventcountlinetmp.create("JourId" => row.JourId.to_s, 
        "ItemId" => row.ItemId.to_s, 
        "InventSizeId"   => row.InventSizeId.to_s, 
        "ItemBarCode" => row.ItemBarCode.to_s,
        "CountedQty" => row.CountedQty.to_s          
       )
       
    TsdInventcountjourtmp.delete_all();
    TsdInventcountlinetmp.delete_all();       
	end
	
	if !(SyncEngine::logged_in > 0)
      SyncEngine.login("1", "1", (url_for :action => :login_callback) )
    end
    $sync_control = "19"
    SyncEngine.dosync_source( TsdInventcountjourtmp, show_sync_status = true, "query[param1]=" + $JourId.to_s )
	end
  end
  
  def upload_invent_4
   $sync_msg = "Выгрузка: Инв. строки" 
  redirect :controller => :Settings, :action => :wait  
	if !(SyncEngine::logged_in > 0)
      SyncEngine.login("1", "1", (url_for :action => :login_callback) )
    end
    $sync_control = "20"
    SyncEngine.dosync_source( TsdInventcountlinetmp, show_sync_status = true, "query[param1]=" + $JourId.to_s )  
  end
 
  def upload_invent_5
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
                  "Operation" => "11",
                  "Status" => status,                      
                  "Comment" => $sync_err_msg.to_s + " Журнал: " + $JourId.to_s)  
  
      if ($sync_err == "0")
#        Alert.show_popup(
#            :message=> "Синхронизация успешно выполнена",
#            :title=>"Сообщение",
#            :buttons => ["Ok"]
#         )  
      end      
      
  	WebView.navigate( url_for :controller => :Invent, :action => :show_detail, :id => $TsdInventcountjourObj)	
  end 
 
   def upload_invent_6 
    redirect :controller => :Settings, :action => :wait         
    @TsdInventcountjours = TsdInventcountjour.find( $TsdInventcountjourObj) 
    @TsdInventcountlines = TsdInventcountline.find(:all,
      :conditions => { 
        {
          :name => "JourId", 
          :op => "IN" 
        } => @TsdInventcountjours.JourId                                 
      }) 	      
      
    if (@params['button_id'] == 'HET')
      upload_invent_5
	    #WebView.navigate( url_for :controller => :Invent, :action => :show_detail, :id => $TsdInventcountjourObj)
    else 
	# Перезапись
	TsdInventcountjourtmp.delete_all();
	TsdInventcountlinetmp.delete_all();
	
	TsdInventcountjourtmp.create("JourId" =>  @TsdInventcountjours.JourId.to_s, 
        "InventLocationId" => @TsdInventcountjours.InventLocationId.to_s, 
        "JourDescription"   => @TsdInventcountjours.JourDescription.to_s, 
        "JourDate" => @TsdInventcountjours.JourDate.to_s,
        "Deleted" => @TsdInventcountjours.Deleted.to_s,
        "Imported" => "1"          
        )

	@TsdInventcountlines.each do |row|
      TsdInventcountlinetmp.create("JourId" => row.JourId.to_s, 
        "ItemId" => row.ItemId.to_s, 
        "InventSizeId"   => row.InventSizeId.to_s, 
        "ItemBarCode" => row.ItemBarCode.to_s,
        "CountedQty" => row.CountedQty.to_s          
       )
       
    TsdInventcountjourtmp.delete_all();
    TsdInventcountlinetmp.delete_all();       
	end
	
	if !(SyncEngine::logged_in > 0)
      SyncEngine.login("1", "1", (url_for :action => :login_callback) )
    end
    $sync_control = "19"
    SyncEngine.dosync_source( TsdInventcountjourtmp, show_sync_status = true, "query[param1]=" + $JourId.to_s )
	end
  end 
  
  # Выгрузка заказа
  def upload_invent
    $msg = ""
    $msg1 = ""
    $msg2 = ""
   
    $sync_msg = "Выгрузка: Запрос Инв." 
    WebView.navigate( url_for( :controller => :Settings, :action => :wait ) )
    @TsdInventcountjours = TsdInventcountjour.find( $TsdInventcountjourObj)   
    @TsdInventcountjours.update_attributes({"Imported" => "1"})  
    @TsdInventcountjours.update_attributes({"Importeds" => "1"})    

	$JourId = @TsdInventcountjours.JourId
	
	TsdInventcountjourselect.delete_all();
	TsdInventcountlineselect.delete_all();	
	
    if !(SyncEngine::logged_in > 0)
      SyncEngine.login("1", "1", (url_for :action => :login_callback) )
    end
    $sync_control = "17"
    SyncEngine.dosync_source( TsdInventcountjourselect, show_sync_status = true, "query[param1]=" + $JourId.to_s )
	
#    Alert.show_popup(
#        :message=> "Jo",
#        :title=>"Сообщение",
#        :buttons => ["Ok"]
#     )   
    
#	render :action => :show_detail, :id => $TsdInventcountjourObj
	
    #WebView.navigate(url_for(:action => :show_detail, :id => $TsdInventcountjourObj))      
  end

  #----------------------------------------------------------------------------------------------
  
  # Приемка товара
  def begin_invent
    $msg = ""
    $msg1 = ""
    $msg2 = ""
    
    WebView.execute_js("nulling();") 
    
    $mstatus = "I_IS"
    
    WebView.navigate(url_for(:action => :I_UNI)) 
    ##WebView.navigate(url_for(:action => :inp_item))         
  end
 
  def I_UNI
    if !System.get_property('is_emulator')
      Scanner.disable
      Scanner.decodeEvent = url_for(:action => :decode_item)
      Scanner.enable
    end              
    
    WebView.execute_js("null_shval();")  
  end    
     
  # переход к просмотру товара
  def before_inp_item
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
  
  # Ввод товара
  def line_edit
    $msg = ""
    @@ItemId =  ""
    @@InventSizeId = ""       
         
    @TsdInventcountjours = TsdInventcountjour.find($TsdInventcountjourObj) 
    @@JourId = @TsdInventcountjours.JourId
    
#    Alert.show_popup(
#        :message=> @TsdInventcountjours,
#        :title=>"Ошибка",
#        :buttons => ["Ok"]
#     )     
    
    # Не ввели код
    if (@params["CODE"] == "")
      
      # Поиск записи в справочнике ШК
      @TSDItembarcodes = TsdItembarcode.find(:first,
               :conditions => { 
               {
               :name => "ItemBarCode", 
               :op => "IN" 
               } => @params["SH"]         
              } )      
                 
      if (!@TSDItembarcodes)
        @TSDItembarcodes = TsdInventcountline.find(:first,
                 :conditions => { 
                 {
                 :name => "ItemBarCode", 
                 :op => "IN" 
                 } => @params["SH"],
                   {
                   :name => "JourId", 
                   :op => "IN" 
                   } => @@JourId                              
                } ) 
      end
                               
       if (!@TSDItembarcodes)
#         Alert.show_popup(
#             :message=> "ШК нет в справочнике!",
#             :title=>"Ошибка",
#             :buttons => ["Ok"]
#          ) 
          $msg = "ШК нет в справочнике!"
         WebView.execute_js("alarm();")  
         WebView.execute_js("msgr('" + $msg.to_s + "');") 
          ##render :action => :inp_item
       else
         @@ItemId =  @TSDItembarcodes.ItemId
         @@InventSizeId = @TSDItembarcodes.InventSizeId        
         
         # Один ли в справочнике размеров
         if (@@InventSizeId != '')
           @TsdInventcountlines = TsdInventcountline.find(:first,
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
           @TsdInventcountlines = TsdInventcountline.find(:first,
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
                  
         # Строки нет в журнале,  добавить её         
         if (!@TsdInventcountlines)             
           TsdInventcountline.create("JourId" => @@JourId, 
           "ItemId" => @@ItemId,
           "ItemBarCode" =>  @TSDItembarcodes.ItemBarCode,    
           "InventSizeId"   => @@InventSizeId, 
           "CountedQty" => "0" )                                                    
         end         
         _do_invent
                        
         WebView.execute_js("ItemName('" + @ItemName.gsub(/["']/,"").to_s + "');")                 
         WebView.execute_js("ItemId('" + @ItemId.to_s + "');")  
         WebView.execute_js("InventSizeId('" + @InventSizeId.to_s + "');")  
         WebView.execute_js("VendCode('" + @VendCode.gsub(/["']/,"").to_s + "');")                                                                                                                                                    
         WebView.execute_js("RetailPrice('" + sprintf("%20.2f", @RetailPrice).to_s + "');")                               
         WebView.execute_js("CountedQty('" + @CountedQty.to_s + "');") 
                
         WebView.execute_js("SH('" + @TSDItembarcodes.ItemBarCode.to_s + "');") 
         #WebView.execute_js("TO_R();")  
         WebView.execute_js("ENT_PR();")  
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
        if (@params["SIZE"] == "")
          @TSDItembarcodes = TsdInventcountline.find(:first,
                   :conditions => { 
                   {
                   :name => "ItemBarCode", 
                   :op => "IN" 
                   } => @params["SH"],
                     {
                     :name => "JourId", 
                     :op => "IN" 
                     } => @@JourId                             
                  } )           
        else
          @TSDItembarcodes = TsdInventcountline.find(:first,
                   :conditions => { 
                   {
                   :name => "ItemBarCode", 
                   :op => "IN" 
                   } => @params["SH"],
                   {
                   :name => "JourId", 
                   :op => "IN" 
                   } => @@JourId,
                   {
                   :name => "InventSizeId", 
                   :op => "IN" 
                   } =>  @params["SIZE"]                               
                  } )             
        end
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
                         
          ##render :action => :inp_item
       else
         @@ItemId =  @TSDItembarcodes.ItemId
         @@InventSizeId = @TSDItembarcodes.InventSizeId
         
         # Один ли в заказе
         @TsdInventcountlines = TsdInventcountline.find(:first,
                  :conditions => { 
                  {
                  :name => "ItemId", 
                  :op => "IN" 
                  } =>  @@ItemId,
                  {
                    :name => "JourId", 
                    :op => "IN" 
                  } => @@JourId                                                                    
                  } 
                  )
                    
         flag = "0"  
         i = "0"
             
         if (@TsdInventcountlines)
           flag = "1"
         else
           flag = "0"  
         end
             
#           @TsdInventcountlines.each do |rec|
#             i = i.to_i + 1
#           end
#
#         if (i.to_i == 0)  
#           flag = "0" 
#         end
#
#         if (i.to_i == 1)  
#           flag = "1" 
#         end
           
#         if (i.to_i > 1)  
#           flag = "2" 
#         end       

#         Alert.show_popup(
#             :message=>   @@JourId.to_s + "|" + @@ItemId.to_s + "|" + flag.to_s,
#             :title=>"Ошибка",
#             :buttons => ["Ok"]
#          )  
         
#         flag = "1"
         
         if (flag == "1") 
           # Перейти на страницу приемки товара
           _do_invent
                   
           WebView.execute_js("ItemName('" + @ItemName.gsub(/["']/,"").to_s + "');")                 
           WebView.execute_js("ItemId('" + @ItemId.to_s + "');")  
           WebView.execute_js("InventSizeId('" + @InventSizeId.to_s + "');")  
           WebView.execute_js("VendCode('" + @VendCode.gsub(/["']/,"").to_s + "');")                                                                                                                                                    
           WebView.execute_js("RetailPrice('" + sprintf("%20.2f", @RetailPrice).to_s + "');")                               
           WebView.execute_js("CountedQty('" + @CountedQty.to_s + "');")                            
           
           WebView.execute_js("SH('" + @TSDItembarcodes.ItemBarCode.to_s + "');") 
           #WebView.execute_js("TO_R();")  
           WebView.execute_js("ENT_PR();")            
         else
           if (flag == "2")                
               # Перейти на страницу ввода размера
             WebView.execute_js("TO_S();")                     
             else
               # Добавыить позицию в журнал
              TsdInventcountline.create("JourId" => @@JourId, 
              "ItemId" => @@ItemId,
              "ItemBarCode" =>  @TSDItembarcodes.ItemBarCode,    
              "InventSizeId"   => @@InventSizeId, 
              "CountedQty" => "0" )                 
               
#             @T = TsdInventcountline.find(:all)
#             @T.each do |line|
#               Alert.show_popup(
#                   :message=>  line,
#                   :title=>"Ошибка",
#                   :buttons => ["Ok"]
#                )                
#             end 
             
             _do_invent
                     
             WebView.execute_js("ItemName('" + @ItemName.gsub(/["']/,"").to_s + "');")                 
             WebView.execute_js("ItemId('" + @ItemId.to_s + "');")  
             WebView.execute_js("InventSizeId('" + @InventSizeId.to_s + "');")  
             WebView.execute_js("VendCode('" + @VendCode.gsub(/["']/,"").to_s + "');")                                                                                                                                                    
             WebView.execute_js("RetailPrice('" + sprintf("%20.2f", @RetailPrice).to_s + "');")                               
             WebView.execute_js("CountedQty('" + @CountedQty.to_s + "');")                               
             
             WebView.execute_js("SH('" + @TSDItembarcodes.ItemBarCode.to_s + "');") 
             #WebView.execute_js("TO_R();")  
             WebView.execute_js("ENT_PR();")                            
           end            
         end                                  
                        
       end                    
    end           
  end
  
  # Ввод размера
  def input_size
    @@InventSizeId = @params["SIZE"]    
                
    @TsdInventcountjours = TsdInventcountjour.find( $TsdInventcountjourObj) 
    @@JourId = @TsdInventcountjours.JourId  
                      
     if (!@params["SIZE"])
#       Alert.show_popup(
#           :message=> "Введенного размера нет!",
#           :title=>"Ошибка",
#           :buttons => ["Ok"]
#        ) 
        $msg = "Введенного размера нет!"
        WebView.execute_js("alarm();") 
        WebView.execute_js("msg('" + $msg.to_s + "');") 
        ##render :action => :inp_item
     else      
       # Один ли в справочнике размеров
       if (@@InventSizeId != '')
         @TsdInventcountlines = TsdInventcountline.find(:first,
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
         @TsdInventcountlines = TsdInventcountline.find(:first,
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
     
       # Поиск записи в справочнике цен
       if (@@InventSizeId != '')
         @TsdInventsums = TsdInventsum.find(:first,
                  :conditions => { 
                  {
                  :name => "ItemId", 
                  :op => "IN" 
                  } => @@ItemId,  
                  {
                  :name => "InventSizeId", 
                  :op => "IN" 
                  } => @@InventSizeId,
                  {
                  :name => "InventLocationId", 
                  :op => "IN" 
                  } => $chk_loc                                           
                 } )  
       else
         @TsdInventsums = TsdInventsum.find(:first,
                  :conditions => { 
                  {
                  :name => "ItemId", 
                  :op => "IN" 
                  } => @@ItemId,  
                  {
                  :name => "InventLocationId", 
                  :op => "IN" 
                  } => $chk_loc                                           
                 } )         
       end    
                                                 
                
       if (!@TsdInventsums)
#         Alert.show_popup(
#             :message=> "Введенного размера нет в справочнике!",
#             :title=>"Ошибка",
#             :buttons => ["Ok"]
#          )  
          $msg = "Введенного размера нет в справочнике!"
         WebView.execute_js("alarm();") 
         WebView.execute_js("msg('" + $msg.to_s + "');") 
         ##render :action => :inp_item        
       else              
         if (!@TsdInventcountlines)
           TsdInventcountline.create("JourId" => @@JourId, 
           "ItemId" => @@ItemId,
           "ItemBarCode" =>  @TSDItembarcodes.ItemBarCode,    
           "InventSizeId"   => @@InventSizeId, 
           "CountedQty" => "0" )                 
         end
         _do_invent
                 
         WebView.execute_js("ItemName('" + @ItemName.to_s + "');")                 
         WebView.execute_js("ItemId('" + @ItemId.to_s + "');")  
         WebView.execute_js("InventSizeId('" + @InventSizeId.to_s + "');")  
         WebView.execute_js("VendCode('" + @VendCode.to_s + "');")                                                                                                  
         WebView.execute_js("R_QTY('" + @CountedQty.to_s + "');")                                                         
         WebView.execute_js("RetailPrice('" + @RetailPrice.to_s + "');")                               
         
         WebView.execute_js("TO_R();")  
         ##redirect :action => :do_invent       
       end
                          
     end   
  end   
  
 # сканирование товара 
 def decode_item
   $msg = ""
   @@ItemId =  ""
   @@InventSizeId = ""
       
   @TsdInventcountjours = TsdInventcountjour.find( $TsdInventcountjourObj) 
   @@JourId = @TsdInventcountjours.JourId
     
     # Поиск записи в справочнике ШК
     @TSDItembarcodes = TsdItembarcode.find(:first,
              :conditions => { 
              {
              :name => "ItemBarCode", 
              :op => "IN" 
              } => @params["data"]         
             } )      
            
   if (!@TSDItembarcodes)
     @TSDItembarcodes = TsdInventcountline.find(:first,
              :conditions => { 
              {
              :name => "ItemBarCode", 
              :op => "IN" 
              } => @params["SH"],
                {
                :name => "JourId", 
                :op => "IN" 
                } => @@JourId                              
             } ) 
   end       
                                  
      if (!@TSDItembarcodes)
#        Alert.show_popup(
#            :message=> "ШК нет в справочнике!",
#            :title=>"Ошибка",
#            :buttons => ["Ok"]
#         ) 
         $msg = "ШК нет в справочнике!"
         WebView.execute_js("alarm();") 
         WebView.execute_js("msg('" + $msg.to_s + "');") 
         ##WebView.navigate(url_for(:action => :inp_item)) 
      else
        @@ItemId =  @TSDItembarcodes.ItemId
        @@InventSizeId = @TSDItembarcodes.InventSizeId
        
        # Один ли в справочнике размеров
        if (@@InventSizeId != '')
          @TsdInventcountlines = TsdInventcountline.find(:first,
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
          @TsdInventcountlines = TsdInventcountline.find(:first,
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
 
        if (!@TsdInventcountlines)
          TsdInventcountline.create("JourId" => @@JourId, 
          "ItemId" => @@ItemId,
          "ItemBarCode" =>  @TSDItembarcodes.ItemBarCode,    
          "InventSizeId"   => @@InventSizeId, 
          "CountedQty" => "0" )          
        end
        
        _do_invent
                       
        WebView.execute_js("ItemName('" + @ItemName.gsub(/["']/,"").to_s + "');")                 
        WebView.execute_js("ItemId('" + @ItemId.to_s + "');")  
        WebView.execute_js("InventSizeId('" + @InventSizeId.to_s + "');")  
        WebView.execute_js("VendCode('" + @VendCode.gsub(/["']/,"").to_s + "');")                                                                                                                                                    
        WebView.execute_js("RetailPrice('" + sprintf("%20.2f", @RetailPrice).to_s + "');")                               
        WebView.execute_js("CountedQty('" + @CountedQty.to_s + "');") 
               

        #WebView.execute_js("TO_R();")  

        $scan_code = @params["data"]         
          
        decode_line;
      end  
      
  ## WebView.execute_js("msg('" + $msg.to_s + "');")         
 end 
  
 # Подготовка данных для показа формы приема товара
 def _do_invent
   @ItemId = @@ItemId 
   @InventSizeId = @@InventSizeId
   @ItemName = ""
   @VendCode = ""

   # Поиск строки в заказе
   if (@@InventSizeId != '')
     @TsdInventcountlines = TsdInventcountline.find(:first,
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
     @TsdInventcountlines = TsdInventcountline.find(:first,
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
               
   @RetailPrice = ""
   @CountedQty = @TsdInventcountlines.CountedQty            
   
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

   # Поиск в справочнике цен
   if (@@InventSizeId != '')
     @TSDInventprices = TsdInventprice.find(:first,
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
     @TSDInventprices = TsdInventprice.find(:first,
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
           
   @RetailPrice = "0"
   
   if (@TSDInventprices)           
     @RetailPrice = @TSDInventprices.RetailPrice    
   end
               
   if (@TSDInventsums)
     @VendCode = @TSDInventsums.VendCode
   end                  
         
#   if !System.get_property('is_emulator')
#     Scanner.disable
#     Scanner.decodeEvent = url_for(:action => :decode_line)
#     Scanner.enable
#   end 

   $TsdInventcountlineObj = @TsdInventcountlines.object           
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
      WebView.execute_js("msg('" + $msg.to_s + "');") 
   end
   if (flag == "0")
     redirect :action => :get_po_checker
   else
     redirect :action => :do_invent
   end
 end
 
 def listern_po_checker
   $po_cycle_check = @params['aj_po_ch'] 
 end
 
 # Обработчик скана позиции в строке
 def decode_line
   @@Scaner_Input = "1"
   ##@@ItemBarCode = @params["data"]
   @@ItemBarCode = $scan_code
   #WebView.execute_js("read_po_checker();")                
   
   # Циклический режим приема заказа    
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
        @TsdInventcountlines = TsdInventcountline.find($TsdInventcountlineObj)               

        if ((@TSDItembarcodes.ItemId == @TsdInventcountlines.ItemId) and 
            (@TSDItembarcodes.InventSizeId == @TsdInventcountlines.InventSizeId))      
                     
             @TsdInventcountlines.update_attributes({"CountedQty" => @TsdInventcountlines.CountedQty.to_i + 1})
             @TsdInventcountjours = TsdInventcountjour.find($TsdInventcountjourObj)
             @TsdInventcountjours.update_attributes({"Importeds" => "0"})
             val =  @TsdInventcountlines.CountedQty.to_i  
             WebView.execute_js("set_r_qty('" + val.to_s + "');")                              
        else
#          Alert.show_popup(
#              :message=> "Неверный ШК текущей позиции!",
#              :title=>"Ошибка",
#              :buttons => ["Ok"]
#           ) 
#           $msg = "Неверный ШК позиции!"   
#           WebView.execute_js("alarm();")  
#           WebView.execute_js("msgr('" + $msg.to_s + "');")         
        end                
      end  
     end             
                                 
 end

  # Обработчик скана позиции в строке
  def decode_line_2
    @@Scaner_Input = "1"
    @@ItemBarCode = @params["data"]
    #WebView.execute_js("read_po_checker();")                
    
    # Циклический режим приема заказа    
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
         @TsdInventcountlines = TsdInventcountline.find($TsdInventcountlineObj)               
 
         if ((@TSDItembarcodes.ItemId == @TsdInventcountlines.ItemId) and 
             (@TSDItembarcodes.InventSizeId == @TsdInventcountlines.InventSizeId))      
                      
              @TsdInventcountlines.update_attributes({"CountedQty" => @TsdInventcountlines.CountedQty.to_i + 1})
              @TsdInventcountjours = TsdInventcountjour.find($TsdInventcountjourObj)
              @TsdInventcountjours.update_attributes({"Importeds" => "0"})
              val =  @TsdInventcountlines.CountedQty.to_i  
              WebView.execute_js("set_r_qty('" + val.to_s + "');")                              
         else
 #          Alert.show_popup(
 #              :message=> "Неверный ШК текущей позиции!",
 #              :title=>"Ошибка",
 #              :buttons => ["Ok"]
 #           ) 
            $msg = "Неверный ШК позиции!"   
            WebView.execute_js("alarm();")  
            WebView.execute_js("msgr('" + $msg.to_s + "');")         
         end                
       end  
      end             
                                  
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
        WebView.execute_js("msg('" + $msg.to_s + "');") 
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
              $msg = "Превышение количества!" 
             WebView.execute_js("alarm();") 
             WebView.execute_js("msg('" + $msg.to_s + "');") 
             WebView.execute_js("nulling();")             
           else
             @TsdReceiptlines.update_attributes({"ReceivedQty" => @TsdReceiptlines.ReceivedQty.to_i + 1})  
             @TsdInventcountjours = TsdInventcountjour.find($TsdInventcountjourObj)
             @TsdInventcountjours.update_attributes({"Importeds" => "0"})                         
           end             
        else
#          Alert.show_popup(
#              :message=> "Неверный ШК текущей позиции!",
#              :title=>"Ошибка",
#              :buttons => ["Ok"]
#           ) 
           $msg = "Неверный ШК позиции!" 
          WebView.execute_js("alarm();")     
          WebView.execute_js("msg('" + $msg.to_s + "');")         
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
       WebView.execute_js("msg('" + $msg.to_s + "');") 
       WebView.execute_js("nulling();")                    
     else
       if (@TsdReceiptlines.ReceivedQty.to_i + @@Input_count.to_i < 0)
#         Alert.show_popup(
#             :message=> "Принятое кол-во не может быть отрицательным! Попробуйте ещё раз...",
#             :title=>"Ошибка",
#             :buttons => ["Ok"]
#          ) 
          $msg = "Кол-во не может быть отриц.!"
         WebView.execute_js("alarm();") 
         WebView.execute_js("msg('" + $msg.to_s + "');") 
         WebView.execute_js("nulling();") 
       else
         @TsdReceiptlines.update_attributes({"ReceivedQty" => @TsdReceiptlines.ReceivedQty.to_i + @@Input_count.to_i}) 
         @TsdInventcountjours = TsdInventcountjour.find($TsdInventcountjourObj)
         @TsdInventcountjours.update_attributes({"Importeds" => "0"})  
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
 end
 

 # Завершение приемки
 def end_receipt 
   redirect :action => :do_invent
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
     cycle_input = $in_cycle_check  
            
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
          @TsdInventcountlines = TsdInventcountline.find( $TsdInventcountlineObj)         
  
          if ((@TSDItembarcodes.ItemId == @TsdInventcountlines.ItemId) and 
              (@TSDItembarcodes.InventSizeId == @TsdInventcountlines.InventSizeId))
                          
               @TsdInventcountlines.update_attributes({"CountedQty" => @TsdInventcountlines.CountedQty.to_i + 1})   
               @TsdInventcountjours = TsdInventcountjour.find($TsdInventcountjourObj)
               @TsdInventcountjours.update_attributes({"Importeds" => "0"})                           
          else
#            Alert.show_popup(
#                :message=> "Неверный ШК текущей позиции!",
#                :title=>"Ошибка",
#                :buttons => ["Ok"]
#             ) 
             $msg = "Неверный ШК позиции!"   
             WebView.execute_js("alarm();")    
             WebView.execute_js("msgr('" + $msg.to_s + "');")
          end                
        end  
       end             
     else
     # Не цикличекский ввод
       # Поиск строки в заказе
       @TsdInventcountlines = TsdInventcountline.find( $TsdInventcountlineObj)       
       
         if (@TsdInventcountlines.CountedQty.to_i + @@Input_count.to_i < 0)
#           Alert.show_popup(
#               :message=> "Принятое кол-во не может быть отрицательным! Попробуйте ещё раз...",
#               :title=>"Ошибка",
#               :buttons => ["Ok"]
#            ) 
           $msg = "Кол-во не может быть отриц.!" 
           WebView.execute_js("alarm();") 
           WebView.execute_js("msgr('" + $msg.to_s + "');") 
           WebView.execute_js("nulling();")   
         else
           @TsdInventcountlines.update_attributes({"CountedQty" => @TsdInventcountlines.CountedQty.to_i + @@Input_count.to_i}) 
           @TsdInventcountjours = TsdInventcountjour.find($TsdInventcountjourObj)
           @TsdInventcountjours.update_attributes({"Importeds" => "0"})  
           val =  @TsdInventcountlines.CountedQty.to_i  
           WebView.execute_js("set_r_qty('" + val.to_s + "');") 
           WebView.execute_js("form_focus();")                     
         end                        
     end                 
   end 
   
   WebView.execute_js("msgr('" + $msg.to_s + "');")       
 end
 
  def I_UNI_
    if !System.get_property('is_emulator')
      Scanner.disable
      Scanner.decodeEvent = url_for(:action => :decode_item)
      Scanner.enable
    end 
  end
 
 def back_to_detail
   $msg = ""  
   if !System.get_property('is_emulator') 
     Scanner.disable
   end
   redirect :action => :show_detail, :id => $TsdInventcountjourObj
 end
 
  def back_to_detail_2
     $msg = ""
     if !System.get_property('is_emulator') 
       Scanner.disable
     end  
     
     WebView.navigate(url_for(:action => :show_detail, :id => $TsdInventcountjourObj)) 
     #redirect :action => :show_detail, :id => $TsdInventcountjourObj
   end
 
end


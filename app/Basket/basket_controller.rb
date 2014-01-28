require 'rho/rhocontroller'
require 'helpers/browser_helper'

class BasketController < Rho::RhoController
  include BrowserHelper

  def login_callback
    if rho_error.unknown_client?( @params['error_message'] )
      Rhom::Rhom.database_client_reset
    end  
  end   
  
  # Подготовка к открытию списка
  def edit_basket
    $msg = ""
    $msg1 = ""
    $msg2 = ""
    
    @chk_loc = $chk_loc
    render :action => :edit_basket
  end  

  def main_menu_2
    WebView.navigate(url_for(:controller => :MainMenu ,:action => :main_menu))
  end
  
  def show_main_menu_basket_
    redirect :action => :show_main_menu_basket
  end

  def show_main_menu_basket_2
    WebView.navigate(url_for(:action => :show_main_menu_basket))
  end
    
  def basket_upload_2
    $sync_msg = "Синхронизация: Корзина"  
    redirect :controller => :Settings, :action => :wait
     @AWSBaskettmps = AWSBasketselect.find(:first,
    :conditions => { 
      {
        :name => "InventLocationId", 
        :op => "IN" 
      } => $chk_loc,
      {
        :name => "UserId", 
        :op => "IN" 
      } => $chk_userid,         
      } 
      )  

    @AWSBaskets = AWSBasket.find(:first,
   :conditions => { 
     {
       :name => "InventLocationId", 
       :op => "IN" 
     } => $chk_loc,
     {
       :name => "UserId", 
       :op => "IN" 
     } => $chk_userid,         
     } 
     )      
    
     if (!@AWSBaskets)
#       Alert.show_popup(
#           :message=> "Корзина пуста!",
#           :title=>"Сообщение",
#           :buttons => ["Ok"]
#        ) 
      $msg2 = "Корзина пуста!"  
         
       WebView.navigate( url_for :controller => :Basket, :action => :show_main_menu_basket)           
     else
           
#    @AWSBaskettmps.each do |basket|
#          Alert.show_popup(
#              :message=> basket,
#              :title=>"Ошибка",
#              :buttons => ["Ok"]
#           ) 
#      end             
      
    if (@AWSBaskettmps)
      Alert.show_popup(
          :message=> "Корзина была выгруженна ранее. Выгрузить заново?",
          :title=>"Внимание",
          :buttons => ["ДА", "HET"],
          :callback => url_for(:action => :on_basket_upload)
          )
    else
      AWSBaskettmp.delete_all()
      AWSBasketselect.delete_all()
        
#      @AWSBaskettmps = AWSBaskettmp.find(:all,
#      :conditions => { 
#        {
#          :name => "InventLocationId", 
#          :op => "IN" 
#        } => $chk_loc,
#        {
#          :name => "UserId", 
#          :op => "IN" 
#        } => $chk_userid,         
#        } )        
#             
#      @AWSBaskettmps.each do |basket|
#        basket.destroy
#      end  
      
      @AWSBaskets = AWSBasket.find(:all,
      :conditions => { 
        {
          :name => "InventLocationId", 
          :op => "IN" 
        } => $chk_loc,
        {
          :name => "UserId", 
          :op => "IN" 
        } => $chk_userid        
        } )              
                         
      @AWSBaskets.each do |rec|       
        AWSBaskettmp.create(
          "InventLocationId" => rec.InventLocationId,      
          "UserId"           => rec.UserId,          
          "ItemBarCode"      => rec.ItemBarCode,          
          "ItemId"           => rec.ItemId,          
          "InventSizeId"     => rec.InventSizeId,          
          "PrintCopies"      => rec.PrintCopies,          
          "LineNum"          => rec.LineNum,          
          "YellowLabel"      => rec.YellowLabel,
          "object"           => rec.object
          )
      end  
      
      AWSBaskettmp.delete_all()
      
      if !(SyncEngine::logged_in > 0)
        SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
      end 
      $sync_control = "8"	
        SyncEngine.dosync_source(AWSBaskettmp, false, "query[param1]=" + $chk_loc.to_s + "&query[param2]=" + $chk_userid.to_s )                     
    end  

  end  
	render :action => :show_main_menu_basket 
  end  
  
  def basket_upload_3
#        if ($sync_err == "0")
#          Alert.show_popup(
#              :message=> "Синхронизация выполнена успешно",
#              :title=>"Сообщение",
#              :buttons => ["Ok"]
#           )                                      
#        end 

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
      
      count = AWSBasket.find(:count)    
      
      TsdLog.create("UserId" => $chk_userid, 
                    "InventLocationId" => $chk_loc,
                    "DeviceID" => $device_id,
                    "Date" => t.strftime("%Y-%m-%d"),
                    "Time" => t.strftime("%S").to_i + t.strftime("%M").to_i*60 + t.strftime("%H").to_i*3600,
                    "Operation" => "7",
                    "Status" =>  status,                      
                    "Comment" => "AWSBasket: " + count.to_s + " строк")          
                    
	WebView.navigate( url_for :controller => :Basket, :action => :show_main_menu_basket)
	#render :action => :show_main_menu_basket 					
  end
  
  
  # Выгрузка корзины
  def basket_upload 
    $msg = ""
    $msg1 = ""
    $msg2 = ""
     
    $sync_msg = "Синхронизация: Корзина запрос остатков" 
    
    redirect :controller => :Settings, :action => :wait
    $sync_err = "0"
    $sync_err_msg = ""
          
    if !(SyncEngine::logged_in > 0)
      SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
    end 
    $sync_control = "7"	
      SyncEngine.dosync_source(AWSBasketselect, true, "query[param1]=" + $chk_loc.to_s + "&query[param2]=" + $chk_userid.to_s )   

    #render :action => :show_main_menu_basket 	  
    #redirect :action => :show_main_menu_basket   
  end 
  
  # Выгрузка корзины подтверждение
  def on_basket_upload
    redirect :controller => :Settings, :action => :wait
    if (@params['button_id'] == 'HET')
      if ($msg = "")        
        $msg1 = "Синхронизация выполненна"
        $msg2 = ""   
      else
        $msg1 = "" 
        $msg2 = $msg                   
      end
      WebView.navigate(url_for(:action => :show_main_menu_basket)) 
    else
      AWSBaskettmp.delete_all()
      #AWSBasketselect.delete_all()

#      @AWSBaskettmps = AWSBaskettmp.find(:all,
#      :conditions => { 
#        {
#          :name => "InventLocationId", 
#          :op => "IN" 
#        } => $chk_loc,
#        {
#          :name => "UserId", 
#          :op => "IN" 
#        } => $chk_userid,         
#        } )        
#             
#      @AWSBaskettmps.each do |basket|
#        basket.destroy
#      end        
              
      @AWSBaskets = AWSBasket.find(:all,
      :conditions => { 
        {
          :name => "InventLocationId", 
          :op => "IN" 
        } => $chk_loc,
        {
          :name => "UserId", 
          :op => "IN" 
        } => $chk_userid,         
        } )  
        
      @AWSBaskets.each do |rec|   
        AWSBaskettmp.create(
          "InventLocationId" => rec.InventLocationId,      
          "UserId"           => rec.UserId,          
          "ItemBarCode"      => rec.ItemBarCode,          
          "ItemId"           => rec.ItemId,          
          "InventSizeId"     => rec.InventSizeId,          
          "PrintCopies"      => rec.PrintCopies,          
          "LineNum"          => rec.LineNum,          
          "YellowLabel"      => rec.YellowLabel,
          "object"           => rec.object.to_s + rec.PrintCopies.to_s         
          )
      end  
      
      AWSBaskettmp.delete_all()
      
      if !(SyncEngine::logged_in > 0)
        SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
      end 
      $sync_control = "8"	
      $sync_msg = "Синхронизация: Корзина" 
        SyncEngine.dosync_source(AWSBaskettmp, true, "query[param1]=" + $chk_loc.to_s + "&query[param2]=" + $chk_userid.to_s )      
      
      #WebView.navigate(url_for(:action => :show_main_menu_basket)) 
    end
  end
  
  # Редактиворание кол-ва
  def edit_basket_p
    @AWSBasketn = AWSBasket.find(@@ASWBasketObj)     
    @AWSBasketn.update_attributes({"PrintCopies" =>  @params['COUNT']})   
      
    #redirect :action => :show_main_menu_basket
    redirect :action => :edit_basket
  end

  def edit_basket_p_2
    @AWSBasketn = AWSBasket.find(@@ASWBasketObj)     
    @AWSBasketn.update_attributes({"PrintCopies" =>  @params['COUNT']})   
      
    #redirect :action => :show_main_menu_basket
    WebView.navigate(url_for(:action => :edit_basket))
    #redirect :action => :edit_basket
  end
    
  # Показ детализации по позиции
  def show_detail
    @AWSBasketn = AWSBasket.find(@params['id'])     
    @@ASWBasketObj = @params['id']  
      
    @ItemId =  ""
    @InventSizeId = ""
   
    @ItemName = "" 
    @VendId   = ""
    @VendName = ""   
    
    @RetailPrice   = "0"
    @SalesPrice    = "0"
    @SalesDiscount = "0"
             
    @VendCode     = ""
    @AvailableQty = "0"
    @OrderedQty   = "0" 
    
    # Поиск записи в справочнике ШК
    @TSDItembarcodes = TsdItembarcode.find(:first,
             :conditions => { 
             {
             :name => "ItemBarCode", 
             :op => "IN" 
             } => @AWSBasketn.ItemBarCode        
            } )      
                                
     if (!@TSDItembarcodes)
#       Alert.show_popup(
#           :message=> "ШК нет в справочнике!",
#           :title=>"Ошибка",
#           :buttons => ["Ok"]
#        )  
       render :action => :edit_basket
     else
       @ItemId =  @TSDItembarcodes.ItemId
       @InventSizeId = @TSDItembarcodes.InventSizeId
      
       @ItemName = "" 
       @VendId   = ""
       @VendName = ""   
       
       @RetailPrice   = "0"
       @SalesPrice    = "0"
       @SalesDiscount = "0"
                
       @VendCode     = ""
       @AvailableQty = "0"
       @OrderedQty   = "0"
                
       # Поиск в справочнике товаров
       @TsdInventtables = TsdInventtable.find(:first,
                :conditions => { 
                {
                :name => "ItemId", 
                :op => "IN" 
                } =>  @ItemId                           
                } )                                             
                
       if (!@TsdInventtables)
#         Alert.show_popup(
#             :message=> "Товара нет в справочнике!",
#             :title=>"Ошибка",
#             :buttons => ["Ok"]
#          )            
       else
         @ItemName = @TsdInventtables.ItemName 
         @VendId   = @TsdInventtables.VendId
         @VendName = @TsdInventtables.VendName 
       end                                            
       
       # Поиск в справочнике цен
       if ( @InventSizeId == "")
         @TSDInventprices = TsdInventprice.find(:first,
                  :conditions => { 
                  {
                  :name => "ItemId", 
                  :op => "IN" 
                  } =>  @ItemId,
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
                  } =>  @ItemId,
                  {
                    :name => "InventSizeId", 
                    :op => "IN" 
                  } =>  @InventSizeId,
                  {
                    :name => "InventLocationId", 
                    :op => "IN" 
                  } =>  $chk_loc                                                                    
                  } )   
       end
                                                
                
       if (@TSDInventprices)
         @RetailPrice   = @TSDInventprices.RetailPrice
         @SalesPrice    = @TSDInventprices.SalesPrice
         @SalesDiscount = @TSDInventprices.SalesDiscount
       end                      
           
       if (@InventSizeId == "")
         # Поиск в справочнике размеров и остатков
         @TSDInventsums = TsdInventsum.find(:first,
                  :conditions => { 
                  {
                  :name => "ItemId", 
                  :op => "IN" 
                  } =>  @ItemId,
                  {
                    :name => "InventLocationId", 
                    :op => "IN" 
                  } => $chk_loc                                                                    
                  } ) 
       else
         # Поиск в справочнике размеров и остатков
         @TSDInventsums = TsdInventsum.find(:first,
                  :conditions => { 
                  {
                  :name => "ItemId", 
                  :op => "IN" 
                  } =>  @ItemId,
                  {
                    :name => "InventSizeId", 
                    :op => "IN" 
                  } => @InventSizeId,
                  {
                    :name => "InventLocationId", 
                    :op => "IN" 
                  } => $chk_loc                                                                    
                  } ) 
       end     
           
        
       if (@TSDInventsums)
         @VendCode     = @TSDInventsums.VendCode
         @AvailableQty = @TSDInventsums.AvailableQty
         @OrderedQty   = @TSDInventsums.OrderedQty
       end           
         
       @VendId = @ItemId
                                        
     end
  
    render :action => :show_detail   
  end
  
  # основное меню корзины
  def show_main_nenu_basket
    render :action => :show_main_menu_basket
  end
  
  # Запрос на очистку корзины
  def basketfill
    $msg = ""
    $msg1 = ""
    $msg2 = ""
    
    Alert.show_popup(
        :message=> "Корзина будет очищена?",
        :title=>"Внимание",
        :buttons => ["ДА", "HET"],
        :callback => url_for(:action => :on_check)
        ) 

    render :action => :show_main_menu_basket    
    #WebView.navigate(url_for(:action => :show_main_menu_basket))        
  end
 
  # Очистка корзины
  def on_check 
    if (@params['button_id'] == 'HET')
      WebView.navigate(url_for(:action => :show_main_menu_basket)) 
    else
      # Корзина
      @AWSBaskets = AWSBasket.find(:all,
      :conditions => { 
      {
      :name => "InventLocationId", 
      :op => "IN" 
      } => $chk_loc                  
     })       
      
      @AWSBaskets.each do |basket|
        basket.destroy
      end
      
      WebView.navigate(url_for(:action => :show_main_menu_basket))                
    end
    
  end
  
end

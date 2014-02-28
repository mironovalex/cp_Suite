
require 'rho/rhocontroller'
require 'helpers/browser_helper'

class ChkItemController < Rho::RhoController
  include BrowserHelper
  
  #Возврат к основному меню
  def go_bask
    $msg = ""
    $msg1 = ""
    $msg2 = ""
    
    if ($basket_load_ftrom_chit == 1)
      if !System.get_property('is_emulator') 
        Scanner.disable
      end 
      redirect :controller => :MainMenu ,:action => :main_menu
    else
      redirect :controller => :Basket, :action => :show_main_nenu_basket
    end
  end
  
  def go_bask_2
    $msg = ""
    $msg1 = ""
    $msg2 = ""
    
    if ($basket_load_ftrom_chit == 1)
      if !System.get_property('is_emulator') 
        Scanner.disable
      end 
      WebView.navigate(url_for(:controller => :MainMenu ,:action => :main_menu))
    else
      WebView.navigate(url_for(:controller => :Basket, :action => :show_main_nenu_basket))
    end
  end
  
  def CI_UNI
    $msg = ""
    $msg1 = ""
    $msg2 = "" 
    
    if !System.get_property('is_emulator')
      Scanner.decodeEvent = url_for(:action => :decode)
      Scanner.enable
    end     
    
    WebView.execute_js("null_val();")  
  end
  
  # Подготовка к показу формы
  def ItemChkInp
    #$msg = ""
    $msg1 = ""
    $msg2 = ""
    # Поиск в справочнике товаров
#    @TsdInventtables = TsdInventtable.find(:all )  
#    count = 0
#    
#    @TsdInventtables.each do |basket|
#      count = count.to_i + 1
#    end    
#    
#    Alert.show_popup(
#        :message=> "Выполненно |" + Time.now.to_s,
#        :title=>"Ошибка",
#        :buttons => ["Ok"]
#     ) 
    
    if !System.get_property('is_emulator')
      Scanner.decodeEvent = url_for(:action => :decode)
      Scanner.enable
    end     
    
    WebView.execute_js("null_val();")  
    
    render         
  end
  
  # Добавление в корзину
  def basketadd
    # Поиск записи в справочнике ШК
#    @TSDItembarcodes = TsdItembarcode.find(:first,
#             :conditions => { 
#             {
#             :name => "ItemId", 
#             :op => "IN" 
#             } => @@ItemId,   
#             {
#             :name => "InventSizeId", 
#             :op => "IN" 
#             } => @@InventSizeId                     
#            } )       
#                
#        
#    if (@@InventSizeId == "")
#      @TSDItembarcodes = TsdItembarcode.find(:first,
#               :conditions => { 
#               {
#               :name => "ItemId", 
#               :op => "IN" 
#               } => @@ItemId                  
#              } )       
#    end        
                
    @AWSBaskets = AWSBasket.find(:all)   
    
    count = 0
    
    @AWSBaskets.each do |basket|
      count = count.to_i + 1
    end
      
    # Поиск в справочнике цен
    if (@@InventSizeId == "")
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
    else
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
    end                                                                       
             
    @YellowLabel = ""         
             
    if (@TSDInventprices)
      @YellowLabel   = @TSDInventprices.YellowLabel
    end                                          
    
#    Alert.show_popup(
#        :message=> @@Itembarcode,
#        :title=>"Ошибка",
#        :buttons => ["Ok"]
#     )    
    
    
    @AWSBaskets = AWSBasket.find(:first,
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
    } =>  $chk_loc,
      {
        :name => "UserId", 
        :op => "IN" 
      } =>  $chk_userid, 
      {
        :name => "ItemBarCode", 
        :op => "IN" 
      } =>  @@Itembarcode                                                                                  
      }
      )  
    
    if (@AWSBaskets)
      @AWSBaskets.update_attributes({"PrintCopies" => @params['COUNT'].to_i + @AWSBaskets.PrintCopies.to_i})       
    else  
    # Запись в корзину        
    AWSBasket.create("InventLocationId" => $chk_loc, 
      "UserId" => $chk_userid,  
      "ItemId" => @@ItemId, 
      #"ItemBarCode" => @TSDItembarcodes.ItemBarCode,
      "ItemBarCode" => @@Itembarcode, 
      "InventSizeId"  => @@InventSizeId, 
      "PrintCopies"   => @params['COUNT'],
      "LineNum"    => count.to_s,
      "YellowLabel"   => @YellowLabel      
      )
    end
#    Alert.show_popup(
#        :message=> @@InventSizeId,
#        :title=>"Ошибка",
#        :buttons => ["Ok"]
#     )        
      
    WebView.execute_js("TO_IS2();") 
    ##redirect :action => :ItemChkInp
  end
  
  # Добавить в корзину
  def addbasket
    WebView.navigate(url_for(:action => :count_inp_basket)) 
  end

  # Добавить в корзину отмена
  def cancel
    WebView.navigate(url_for(:action => :ItemChkInp)) 
  end
    
  # обработчик сканирования
  def decode
    @@Itembarcode = ""
    @@ItemId =  ""
    @@InventSizeId = ""
   
    @@ItemName = "" 
    @@VendId   = ""
    @@VendName = ""   
    
    @@RetailPrice   = "0"
    @@SalesPrice    = "0"
    @@SalesDiscount = "0"
             
    @@VendCode     = ""
    @@AvailableQty = "0"
    @@OrderedQty   = "0" 
    
    # Поиск записи в справочнике ШК
    @TSDItembarcodes = TsdItembarcode.find(:first,
             :conditions => { 
             {
             :name => "ItemBarCode", 
             :op => "IN" 
             } => @params["data"]         
            } )      
                                
     if (!@TSDItembarcodes)
#       Alert.show_popup(
#           :message=> "ШК нет в справочнике!",
#           :title=>"Ошибка",
#           :buttons => ["Ok"]
#        ) 
        
       $msg = "ШК нет в справочнике!"  
       WebView.execute_js("alarm();")  
       WebView.execute_js("msg('" + $msg.to_s + "');")  
       WebView.execute_js("SH('" + @params["data"].to_s + "');")  
       #WebView.execute_js("TO_I();")     
       #render :action => :ItemChkInp
     else
       $msg = ""
       @@ItemId =  @TSDItembarcodes.ItemId
       @@InventSizeId = @TSDItembarcodes.InventSizeId
      
       @@ItemName = "" 
       @@VendId   = ""
       @@VendName = ""   
       
       @@RetailPrice   = "0"
       @@SalesPrice    = "0"
       @@SalesDiscount = "0"
                
       @@VendCode     = ""
       @@AvailableQty = "0"
       @@OrderedQty   = "0"
                
       # Поиск в справочнике товаров
       @TsdInventtables = TsdInventtable.find(:first,
                :conditions => { 
                {
                :name => "ItemId", 
                :op => "IN" 
                } =>  @@ItemId                           
                } )                                             
                
       if (!@TsdInventtables)
#         Alert.show_popup(
#             :message=> "Товара нет в справочнике!",
#             :title=>"Ошибка",
#             :buttons => ["Ok"]
#          ) 
          $msg = "Товара нет в справочнике!" 
          WebView.execute_js("alarm();")  
          WebView.execute_js("msg('" + $msg.to_s + "');")  
          WebView.execute_js("SH('" + @params["data"].to_s + "');")  
          #WebView.execute_js("TO_I();")          
       else
         $msg = ""           
         @@ItemName = @TsdInventtables.ItemName 
         @@VendId   = @TsdInventtables.VendId
         @@VendName = @TsdInventtables.VendName 
       end                                            
       
       if (@@InventSizeId == "")
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
       else
       # Поиск в справочнике цен
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
     end
                         
       if (@TSDInventprices)
         @@RetailPrice   = @TSDInventprices.RetailPrice
         @@SalesPrice    = @TSDInventprices.SalesPrice
         @@SalesDiscount = @TSDInventprices.SalesDiscount
       end                      
              
       if (@@InventSizeId == "")         
       # Поиск в справочнике размеров и остатков
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
       else
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
       end                    
        
       if ( @TSDInventsums)
         @@VendCode     = @TSDInventsums.VendCode
         @@AvailableQty = @TSDInventsums.AvailableQty
         @@OrderedQty   = @TSDInventsums.OrderedQty
       end           
       
       # Перейти на страницу отображения данных товара
       WebView.execute_js("ItemName('" + @@ItemName.gsub(/["']/,"").to_s + "');")                  
       WebView.execute_js("ItemId('" + @@ItemId.to_s + "');")  
       WebView.execute_js("InventSizeId('" + @@InventSizeId.gsub(/["']/,"").to_s + "');")  
       WebView.execute_js("VendId('" + @@ItemId.to_s + "');")                               
       WebView.execute_js("VendName_('" + @@VendName.gsub(/["']/,"").to_s + "');")                            
       WebView.execute_js("RetailPrice('" + sprintf("%20.2f", @@RetailPrice).to_s + "');")                               
       WebView.execute_js("SalesPrice('" + sprintf("%20.2f", @@SalesPrice).to_s + "');")                               
       WebView.execute_js("SalesDiscount('" + sprintf("%20.2f", @@SalesDiscount).to_s + "');")                               
       WebView.execute_js("VendCode('" + @@VendCode.to_s + "');")                               
       WebView.execute_js("AvailableQty('" + @@AvailableQty.to_s + "');")                               
       WebView.execute_js("OrderedQty('" + @@OrderedQty.to_s + "');")                                  
       
       @@Itembarcode = @params["data"].to_s
       
       WebView.execute_js("msg('" + '' + "');")  
       WebView.execute_js("SH('" + @params["data"].to_s + "');")  
       #WebView.execute_js("TO_IS();") 
       ##WebView.navigate(url_for(:action => :show_item))                                      
     end
    
  end
  
  def alert
    WebView.execute_js("alarm_('" + Rho::RhoApplication::get_base_app_path().to_s() + 'public/Error.wav' + "');")  
  end  
  
  # Обработчик ввода ШК либо номенклатуры товара вручную
  def item_show
    @@ItemId =  ""
    @@InventSizeId = ""
    @@Itembarcode = ""
   
    @@ItemName = "" 
    @@VendId   = ""
    @@VendName = ""   
    
    @@RetailPrice   = "0"
    @@SalesPrice    = "0"
    @@SalesDiscount = "0"
             
    @@VendCode     = ""
    @@AvailableQty = "0"
    @@OrderedQty   = "0"
    
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
          WebView.execute_js("msg('" + $msg.to_s + "');")  
          WebView.execute_js("SH('" + @params["SH"].to_s + "');") 
          ##render :action => :ItemChkInp
       else
         $msg = ""         
         @@ItemId =  @TSDItembarcodes.ItemId
         @@InventSizeId = @TSDItembarcodes.InventSizeId
         
         @@ItemName = "" 
         @@VendId   = ""
         @@VendName = ""   
         
         @@RetailPrice   = "0"
         @@SalesPrice    = "0"
         @@SalesDiscount = "0"
                  
         @@VendCode     = ""
         @@AvailableQty = "0"
         @@OrderedQty   = "0"
                  
         # Поиск в справочнике товаров
         @TsdInventtables = TsdInventtable.find(:first,
                  :conditions => { 
                  {
                  :name => "ItemId", 
                  :op => "IN" 
                  } =>  @@ItemId                           
                  } )                                             
                  
         if (!@TsdInventtables)
#           Alert.show_popup(
#               :message=> "Товара нет в справочнике!",
#               :title=>"Ошибка",
#               :buttons => ["Ok"]
#            )   
           $msg = "ШК нет в справочнике!" 
           WebView.execute_js("alarm();") 
           WebView.execute_js("msg('" + $msg.to_s + "');")    
           WebView.execute_js("SH('" + @params["SH"].to_s + "');")        
         else
           $msg = ""
           @@ItemName = @TsdInventtables.ItemName 
           @@VendId   = @TsdInventtables.VendId
           @@VendName = @TsdInventtables.VendName 
         end                                            
         
         if (@@InventSizeId == "")
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
         else
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
         end                                               
                  
         if (@TSDInventprices)
           @@RetailPrice   = @TSDInventprices.RetailPrice
           @@SalesPrice    = @TSDInventprices.SalesPrice
           @@SalesDiscount = @TSDInventprices.SalesDiscount
         end                      
             
         if (@@InventSizeId == "")
           # Поиск в справочнике размеров и остатков
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
         else
           # Поиск в справочнике размеров и остатков
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
         end       
          
         if (@TSDInventsums)
           @@VendCode     = @TSDInventsums.VendCode
           @@AvailableQty = @TSDInventsums.AvailableQty
           @@OrderedQty   = @TSDInventsums.OrderedQty
         end                    
         
         # Перейти на страницу отображения данных товара
         ##redirect :action => :show_item                                     
         
         WebView.execute_js("ItemName('" + @@ItemName.gsub(/["']/,"").to_s + "');")                  
         WebView.execute_js("ItemId('" + @@ItemId.to_s + "');")  
         WebView.execute_js("InventSizeId('" + @@InventSizeId.gsub(/["']/,"").to_s + "');")  
         WebView.execute_js("VendId('" + @@ItemId.to_s + "');")                               
         WebView.execute_js("VendName_('" + @@VendName.gsub(/["']/,"").to_s + "');")                            
         WebView.execute_js("RetailPrice('" + sprintf("%20.2f", @@RetailPrice).to_s + "');")                               
         WebView.execute_js("SalesPrice('" + sprintf("%20.2f", @@SalesPrice).to_s + "');")                               
         WebView.execute_js("SalesDiscount('" + sprintf("%20.2f", @@SalesDiscount).to_s + "');")                           
         WebView.execute_js("VendCode('" + @@VendCode.to_s + "');")                               
         WebView.execute_js("AvailableQty('" + @@AvailableQty.to_s + "');")                               
         WebView.execute_js("OrderedQty('" + @@OrderedQty.to_s + "');")                   
         
         WebView.execute_js("msg('" + '' + "');")   
         @@Itembarcode = @params["SH"].to_s          
            
         #WebView.execute_js("SH('" + @params["SH"].to_s + "');")   
         #WebView.execute_js("TO_IS();")                                  
       end
    #Ввели код номенклатуры вместо ШК              
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
          WebView.execute_js("msg('" + $msg.to_s + "');") 
          WebView.execute_js("SH('" + '' + "');")  
          #render :action => :ItemChkInp
       else
         $msg = ""
         @@ItemId =  @TSDItembarcodes.ItemId
         @@InventSizeId = @TSDItembarcodes.InventSizeId
        
         @@ItemName = "" 
         @@VendId   = ""
         @@VendName = ""   
         
         @@RetailPrice   = "0"
         @@SalesPrice    = "0"
         @@SalesDiscount = "0"
                  
         @@VendCode     = ""
         @@AvailableQty = "0"
         @@OrderedQty   = "0"
                  
         # Поиск в справочнике товаров
         @TsdInventtables = TsdInventtable.find(:first,
                  :conditions => { 
                  {
                  :name => "ItemId", 
                  :op => "IN" 
                  } =>  @@ItemId                           
                  } )                                             
                  
         if (!@TsdInventtables)
#           Alert.show_popup(
#               :message=> "Товара нет в справочнике!",
#               :title=>"Ошибка",
#               :buttons => ["Ok"]
#            )  
            $msg = "Товара нет в справочнике!"   
           WebView.execute_js("alarm();") 
           WebView.execute_js("msg('" + $msg.to_s + "');")  
           WebView.execute_js("SH('" + '' + "');")         
         else
           $msg = ""
           @@ItemName = @TsdInventtables.ItemName 
           @@VendId   = @TsdInventtables.VendId
           @@VendName = @TsdInventtables.VendName 
         end                                            
                  
         
         # Один ли в справочнике размеров
#         @TSDInventsums = TsdItemBarcode.find(:all,
#                  :conditions => { 
#                  {
#                  :name => "ItemId", 
#                  :op => "IN" 
#                  } =>  @@ItemId                                                                   
#                  } )
                      
          
#         @TSDInventsums = TsdItembarcode.find_by_sql("SELECT DISTINCT ItemId, InventSizeId FROM TsdItemBarcode WHERE ItemId = '" + @@ItemId.to_s + "'")       
                 
#         Alert.show_popup(
#             :message=> 'Jo',
#             :title=>"Ошибка",
#             :buttons => ["Ok"]
#          )                   
                        
#         flag = "0"  
#         i = "0"
#         if (@TSDInventsums)           
#           flag = "1"
#           @TSDInventsums.each do |user|
#             i = i.to_i + 1
#           end
#           if (i.to_i > 1)
#             flag = "2"
#           end
#         end                  
         
         flag = "1"
         
         if (flag != "2")                
            # Поиск в справочнике цен
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
                  
              if (@TSDInventprices)
                @@RetailPrice   = @TSDInventprices.RetailPrice
                @@SalesPrice    = @TSDInventprices.SalesPrice
                @@SalesDiscount = @TSDInventprices.SalesDiscount
              end                      
                  
              # Поиск в справочнике размеров и остатков
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
          
                if (@TSDInventsums)
                   @@VendCode     = @TSDInventsums.VendCode
                   @@AvailableQty = @TSDInventsums.AvailableQty
                   @@OrderedQty   = @TSDInventsums.OrderedQty
                end                 
                
             # Перейти на страницу отображения данных товара
             ##redirect :action => :show_item                       

           #@@VendName = @@VendName.gsub(/["']/,"")     
                
           WebView.execute_js("ItemName('" + @@ItemName.gsub(/["']/,"").to_s + "');")                  
           WebView.execute_js("ItemId('" + @@ItemId.to_s + "');")  
           WebView.execute_js("InventSizeId('" + @@InventSizeId.gsub(/["']/,"").to_s + "');")  
           WebView.execute_js("VendId('" + @@ItemId.to_s + "');")                               
           WebView.execute_js("VendName_('" + @@VendName.gsub(/["']/,"").to_s + "');")                            
           WebView.execute_js("RetailPrice('" + sprintf("%20.2f", @@RetailPrice).to_s + "');")                               
           WebView.execute_js("SalesPrice('" + sprintf("%20.2f", @@SalesPrice).to_s + "');")                               
           WebView.execute_js("SalesDiscount('" + sprintf("%20.2f", @@SalesDiscount).to_s + "');")                               
           WebView.execute_js("VendCode('" + @@VendCode.to_s + "');")                               
           WebView.execute_js("AvailableQty('" + @@AvailableQty.to_s + "');")                               
           WebView.execute_js("OrderedQty('" + @@OrderedQty.to_s + "');")                  
            
           WebView.execute_js("msg('" + '' + "');")      
           
           @@Itembarcode = @TSDItembarcodes.ItemBarCode.to_s
           
#                               Alert.show_popup(
#                                   :message=>  @@Itembarcode.to_s,
#                                   :title=>"Ошибка",
#                                   :buttons => ["Ok"]
#                                )             
           
#           WebView.execute_js("SH('" + @TSDItembarcodes.ItemBarCode.to_s + "');") 
#                    Alert.show_popup(
#                        :message=>  'J0',
#                        :title=>"Ошибка",
#                        :buttons => ["Ok"]
#                     )              
               
             #WebView.execute_js("TO_IS();")                   
           else
             # Перейти на страницу ввода размера
             ##redirect :action => :inp_size
             #WebView.execute_js("TO_IS();")                               
         end
                              
       end      
              
    end
    
  end
  
  # Ввод размера
  def input_size
    @@InventSizeId = @params["SIZE"]    
        
    # Поиск в справочнике товаров 
    @TsdInventtables = TsdItembarcode.find(:first,
             :conditions => { 
             {
             :name => "ItemId", 
             :op => "IN" 
             } =>  @@ItemId,
             {
             :name => "InventSizeId", 
             :op => "IN" 
             } =>  @@InventSizeId                                         
             } )       
                              
     if (!@TsdInventtables)
#       Alert.show_popup(
#           :message=> "Введенного размера нет!",
#           :title=>"Ошибка",
#           :buttons => ["Ok"]
#        ) 
       $msg = "Введенного размера нет!"  
       WebView.execute_js("alarm();") 
       WebView.execute_js("TO_I();")  
       WebView.execute_js("msg('" + $msg.to_s + "');")        
       ##render :action => :ItemChkInp
     else      
       $msg = ""
       @@ItemName = "" 
       @@VendId   = ""
       @@VendName = ""   
       
       @@RetailPrice   = "0"
       @@SalesPrice    = "0"
       @@SalesDiscount = "0"
                
       @@VendCode     = ""
       @@AvailableQty = "0"
       @@OrderedQty   = "0"
                
#       Alert.show_popup(
#           :message=> "Jo!",
#           :title=>"Ошибка",
#           :buttons => ["Ok"]
#        ) 
       
       # Поиск в справочнике товаров 
       @TsdInventtables = TsdInventtable.find(:first,
                :conditions => { 
                {
                :name => "ItemId", 
                :op => "IN" 
                } =>  @@ItemId                                      
                } )                                             
                
       if (!@TsdInventtables)
#         Alert.show_popup(
#             :message=> "Товара нет в справочнике!",
#             :title=>"Ошибка",
#             :buttons => ["Ok"]
#          ) 
         $msg = "Товара нет в справочнике!"
         WebView.execute_js("alarm();") 
         WebView.execute_js("TO_I();") 
         WebView.execute_js("msg('" + $msg.to_s + "');")                  
       else
         $msg = "" 
         @@ItemName = @TsdInventtables.ItemName 
         @@VendId   = @TsdInventtables.VendId
         @@VendName = @TsdInventtables.VendName 
       end                                            
       
#                Alert.show_popup(
#                    :message=> "Jo!",
#                    :title=>"Ошибка",
#                    :buttons => ["Ok"]
#                 ) 
       
       if (@@InventSizeId == "")
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
       else
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
       end                                               
                
       if (@TSDInventprices)
         @@RetailPrice   = @TSDInventprices.RetailPrice
         @@SalesPrice    = @TSDInventprices.SalesPrice
         @@SalesDiscount = @TSDInventprices.SalesDiscount
       end                      
           
       if (@@InventSizeId == "")
         # Поиск в справочнике размеров и остатков
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
       else
         # Поиск в справочнике размеров и остатков
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
       end       
        
       if (@TSDInventsums)
         @@VendCode     = @TSDInventsums.VendCode
         @@AvailableQty = @TSDInventsums.AvailableQty
         @@OrderedQty   = @TSDInventsums.OrderedQty
       end                    
       
       # Перейти на страницу отображения данных товара
       WebView.execute_js("ItemName('" + @@ItemName.gsub(/["']/,"").to_s + "');")                  
       WebView.execute_js("ItemId('" + @@ItemId.to_s + "');")  
       WebView.execute_js("InventSizeId('" + @@InventSizeId.gsub(/["']/,"").to_s + "');")  
       WebView.execute_js("VendId('" + @@ItemId.to_s + "');")                               
       WebView.execute_js("VendName_('" + @@VendName.gsub(/["']/,"").to_s + "');")                            
       WebView.execute_js("RetailPrice('" + sprintf("%20.2f", @@RetailPrice).to_s + "');")                               
       WebView.execute_js("SalesPrice('" + sprintf("%20.2f", @@SalesPrice).to_s + "');")                               
       WebView.execute_js("SalesDiscount('" + sprintf("%20.2f", @@SalesDiscount).to_s + "');")                                
       WebView.execute_js("VendCode('" + @@VendCode.to_s + "');")                               
       WebView.execute_js("AvailableQty('" + @@AvailableQty.to_s + "');")                               
       WebView.execute_js("OrderedQty('" + @@OrderedQty.to_s + "');")                                      
       
       #@@Itembarcode = @TSDItembarcodes.ItemBarCode.to_s
       
       WebView.execute_js("TO_IS();") 
       ##redirect :action => :show_item                                 
     end
         
  end
  
  # Подготовка к показу товара
  def show_item        
    @ItemId =  @@ItemId
    @InventSizeId = @@InventSizeId   
         
    @ItemName =  @@ItemName 
    @VendId   =  @@VendId
    @VendName =  @@VendName   
    
    @RetailPrice   = @@RetailPrice
    @SalesPrice    = @@SalesPrice
    @SalesDiscount = @@SalesDiscount
             
    @VendCode     = @@VendCode
    @AvailableQty = @@AvailableQty
    @OrderedQty   = @@OrderedQty
            
    render :action => :show_item 
  end  
    
end

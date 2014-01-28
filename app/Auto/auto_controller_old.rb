require 'rho/rhocontroller'
require 'rho/rhofsconnector'
require 'helpers/browser_helper'
require 'rho/rhoutils'

class AutoController < Rho::RhoController
  include BrowserHelper
  
def tst
  a = "Русский"
  
  a = "Russian"
  
  WebView.execute_js("msg('" + a.to_s + "');")   
end  
  
def sync_one

  $msg = ""
  $sync_msg = ""
  $sync_msg = "Синхронизация: Регистрация" 
  redirect :controller => :Settings, :action => :wait
  #WebView.navigate(url_for(:controller => :Settings, :action => :wait)) 
      
	if !(SyncEngine::logged_in > 0)
      SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
    end 
  
 #TsdLog.set_notification(url_for(:action => :inp_location_2), "")  
      
#        Alert.show_popup(
#            :message=> "Jo",
#            :title=>"Внимание",
#            :buttons => ["Ok"]
#         )      
    
	$sync_control = "0"
  SyncEngine.dosync_source(TsdLog) 
   
end  
  
 def inp_location_
     WebView.navigate(url_for(:action => :inp_location)) 
     #redirect :action => :inp_location
 end 
  
  # Открытие формы
  def inp_location     
    #SyncEngine.enable_status_popup(true)
    SyncEngine.set_pagesize(10000)
    
    $sync_control = ""
    $sync_err = "0"
    $sync_err_msg = ""
    $device_id = ""
    $Last_loc = ""
    $chk_loc = ""
    $po_cycle_check = "1"
    $in_cycle_check = "1"    
    $picker_w = "0"
    $picker_o = "0"
        
    #exec Rho::RhoApplication::get_base_app_path() + '/public/notepad.exe'
    
    #WebView.full_screen_mode(1)
    
    dnload_sysvar()  
	
    @last_loc = $Last_loc  
	
	#dnload_location_user()            
    $sync_msg = "" 
    render :action => :inp_location
  end
  
  def inp_location_2     
      WebView.navigate( url_for :controller => :Settings, :action => :wait)  
      if !(SyncEngine::logged_in > 0)
          SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
        end 
        
      #TsdUserinfo.set_notification(url_for(:action => :inp_location_3), "")    
        
      $sync_msg = "Загружаются: Пользователи"  
        
      $sync_control = "1"
      SyncEngine.dosync_source(TsdUserinfo)      
  
  end  
 
 def inp_location_3  
     WebView.navigate( url_for :controller => :Settings, :action => :wait)  
     if !(SyncEngine::logged_in > 0)
         SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
       end 
     
      #TsdInventlocation.set_notification(url_for(:action => :inp_location_4), "")        
           
     $sync_msg = "Загружаются: Магазины"        
       
     $sync_control = "2"
     SyncEngine.dosync_source(TsdInventlocation)      
   
  end  
  
  def inp_location_4
    WebView.navigate( url_for :controller => :Auto, :action => :inp_location)  
  end
  
  # GET /Auto
  def index
    @autos = Auto.find(:all)
    render :back => '/app'
  end

  # Выбраный магазин
  def chech_location
    $picker_w = "0"
    #$chk_loc =  @params["chk_val"] 
    $chk_loc =  @@LOC             
    #WebView.navigate(url_for(:action => :inp_login))
    redirect :action => :inp_login            
  end

  # Выбраный пользователь
  def chech_user   
    if ( @@USER2 != "")
      $chk_user =  @@USER2
    else
      $chk_user =  @@USER1      
    end         
          
    @TsdUserinfos = TsdUserinfo.find(:first,
             :conditions => { 
             {
             :name => "UserName", 
             :op => "IN" 
             } => $chk_user,
             {
             :name => "InventLocationId", 
             :op => "IN" 
             } => $chk_loc          
            } )           
            
    if (!@TsdUserinfos)
      #WebView.navigate(url_for(:action => :inp_password)) 
      redirect :action => :inp_password
    else
      $chk_userid =  @TsdUserinfos.UserId
      if (@TsdUserinfos.SetPassword == "1")
        #WebView.navigate(url_for(:action => :inp_password_conf)) 
        redirect :action => :inp_password_conf
      else
        #WebView.navigate(url_for(:action => :inp_password))  
        redirect :action => :inp_password      
      end 
    end                          
           
  end
    
  # Открытие формы ввода пользователя
  def inp_login
    @chk_location = $chk_loc
      
    
#    @TsdUserinfos = TsdUserinfo.find(:all)   
#   
#           @TsdUserinfos.each do |user|
#             Alert.show_popup(
#                 :message=> user,
#                 :title=>"Внимание",
#                 :buttons => ["Ok"]
#              )              
#           end            
  end

  # ввод пароля пользователем
  def password_inp
    # Проверка введенного пароля на совпадение с повторением
    if (@params["PASSWORD1"] != @params["PASSWORD2"])
#      Alert.show_popup(
#          :message=> "Введенный пароль не соврадает с подтвержденным! Попробуйте ещё раз",
#          :title=>"Внимание",
#          :buttons => ["Ok"]
#       )  
       
      $msg =  "Введенный пароль не соврадает с подтвержденным! Попробуйте ещё раз"     
          
      WebView.execute_js("null_val();")         
                 
      redirect :action => :inp_password_conf    
    else 
    $msg = ""
    @@chk_pas = @params["PASSWORD1"]   
     
    # Есть ли введенный пользователь  
    @TsdUserinfos = TsdUserinfo.find(:first,
             :conditions => { 
             {
             :name => "UserName", 
             :op => "IN" 
             } => $chk_user          
            } )                                          
            
    if ( @TsdUserinfos) 
      # Обновление пароля и признака его ввода в таблице
      @TsdUserinfos.update_attributes({"Password" => @@chk_pas, "SetPassword" => "0"})                   
        
      # Запись в лог    
      t = Time.now        
      
      TsdLog.create("UserId" => @TsdUserinfos.UserId, 
                    "InventLocationId" => $chk_loc,
                    "DeviceID" => $device_id,
                    "Date" => t.strftime("%Y-%m-%d"),
                    "Time" => t.strftime("%S").to_i + t.strftime("%M").to_i*60 + t.strftime("%H").to_i*3600,
                    "Operation" => "0",
                    "Status" => "0",                      
                    "Comment" => "")    
    end                 
    
    # Обновление системной переменной о последнем магазине            
    @SysVars = SysVar.find(
    :first,
    :conditions => { 
      {
        :name => "Var", 
        :op => "IN" 
      } => "Last_Location" 
      } 
     )  
    
    if (!@SysVars)
      SysVar.create("Var" => "Last_Location", "Val" => "")
    else
      @SysVars.update_attributes({"Val" => $chk_loc})
      $Last_loc = $chk_loc  
    end              
    
    # синхронизация таблицы пользователей и лога
      if !(SyncEngine::logged_in > 0)
        SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
      end 
	  
	  $sync_control = "-1"
	  
      SyncEngine.dosync_source(TsdLog)  
      SyncEngine.dosync_source(TsdUserinfo)  
    
    # Переход на новую страницу  
    $msg = ""      
    $msg1 = ""
    $msg2 = ""             
    redirect :controller => :MainMenu, :action => :main_menu
    end
  end
  
  # Ввод пароля
  def password_check
    @@chk_pas = @params["PASSWORD"]
      
    # Есть ли введенный пользователь  
    @TsdUserinfos = TsdUserinfo.find(:first,
             :conditions => { 
             {
             :name => "UserName", 
             :op => "IN" 
             } => $chk_user,
             {
             :name => "Password", 
             :op => "IN" 
             } => @@chk_pas          
            } )               
            
    if ( @TsdUserinfos) 
      t = Time.now
      
      # Запись в лог    
      TsdLog.create("UserId" => @TsdUserinfos.UserId, 
                    "InventLocationId" => $chk_loc,
                    "DeviceID" => $device_id,
                    "Date" => t.strftime("%Y-%m-%d"),
                    "Time" => t.strftime("%S").to_i + t.strftime("%M").to_i*60 + t.strftime("%H").to_i*3600,
                    "Operation" => "0",
                    "Comment" => "")
       
      # Обновление системной переменной о последнем магазине            
      @SysVars = SysVar.find(
      :first,
      :conditions => { 
        {
          :name => "Var", 
          :op => "IN" 
        } => "Last_Location" 
        } 
       )  
      
      if (!@SysVars)
        SysVar.create("Var" => "Last_Location", "Val" => "")
      else
        @SysVars.update_attributes({"Val" => $chk_loc})
        $Last_loc = $chk_loc  
      end              
                    
      # Переход на новую страницу    
      $msg = "" 
      $msg1 = ""
      $msg2 = ""         
      redirect :controller => :MainMenu, :action => :main_menu
    else
          $msg = "Неверный пароль!"
#          Alert.show_popup(
#              :message=> "Неверная учетная запись!",
#              :title=>"Внимание",
#              :buttons => ["Ok"]
#           )   
      redirect :action => :inp_location     
    end 
    
  end
  
  def user_check_
    WebView.navigate(url_for(:action => :user_check))   
  end
  
  # Обработчик ввода пользователя
  def user_check
    @@USER1 = @params["USER1"]
    @@USER2 = @params["USER2"]
    #WebView.execute_js("get_chk_value();")
    #render :action => :inp_login
    #redirect :action => :chech_user
    
    if ( @@USER2 != "")
      $chk_user =  @@USER2
    else
      $chk_user =  @@USER1      
    end         
          
    @TsdUserinfos = TsdUserinfo.find(:first,
             :conditions => { 
             {
             :name => "UserName", 
             :op => "IN" 
             } => $chk_user,
             {
             :name => "InventLocationId", 
             :op => "IN" 
             } => $chk_loc          
            } )           
            
    if (!@TsdUserinfos)
      #WebView.navigate(url_for(:action => :inp_password)) 
      redirect :action => :inp_password
    else
      $chk_userid =  @TsdUserinfos.UserId
      if (@TsdUserinfos.SetPassword == "1")
        #WebView.navigate(url_for(:action => :inp_password_conf)) 
        $msg = ""
        redirect :action => :inp_password_conf
      else
        #WebView.navigate(url_for(:action => :inp_password))  
        redirect :action => :inp_password      
      end 
    end       
  end
  
  def loc_check_
    WebView.navigate(url_for(:action => :loc_check)) 
  end
  
  # Обработчик ввода магазина
  def loc_check   
    @@LOC =  @params['LOC'] 
    @@LOCID =  @params['LOCID']   
    #WebView.execute_js("get_chk_val();")
     
#          Alert.show_popup(
#              :message=> @@LOC.to_s + "|1|" + @@LOCID.to_s,
#              :title=>"Сообщение",
#              :buttons => ["Ok"]
#           )        
      
    @TSDInventlocations = TsdInventlocation.find(:first,
          :conditions => { 
          {
            :name => "InventLocationId", 
            :op => "IN" 
          } =>  @@LOCID                                                                    
          } ) 
                
    if (@TSDInventlocations)
      @@LOC = @@LOCID
    end  

#    Alert.show_popup(
#        :message=> @@LOC.to_s + "|2|" + @@LOCID.to_s,
#        :title=>"Сообщение",
#        :buttons => ["Ok"]
#     )  
    #redirect :action => :chech_location
    
    $picker_w = "0"
    #$chk_loc =  @params["chk_val"] 
    $chk_loc =  @@LOC             
    #WebView.navigate(url_for(:action => :inp_login))
    redirect :action => :inp_login     
  end
  
  
  def login_callback
#    errCode = @params['error_code'].to_i
#    if errCode != 0
#      Alert.show_popup(
#          :message=> "Ошибка синхронизации :" +  @params['error_message'].to_s + " !",
#          :title=>"Внимание",
#          :buttons => ["Ok"]
#       ) 
#    else
#      Alert.show_popup(
#          :message=> "Синхронтзация выполнена.",
#          :title=>"Сообщение",
#          :buttons => ["Ok"]
#       )      
#    end    
  end
  
  def resetdb        
    Alert.show_popup(
        :message=> "Все данные в БД ТСД будут удалены. Выполнить?",
        :title=>"Внимание",
        :buttons => ["ДА", "HET"],
        :callback => url_for(:action => :on_reset)
        )
	
#    if !(SyncEngine::logged_in > 0)
#      SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
#    end 
    
    #    SyncEngine.dosync_source(TsdLog, false, "query[param]=12abc")  
#    SyncEngine.dosync
  end
  
  def on_reset 
    if (@params['button_id'] == 'HET')
      WebView.navigate Rho::RhoConfig.start_path
    else
#      if !(SyncEngine::logged_in > 0)
#        SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
#      end       
#      
#
#       SyncEngine.dosync_source(TsdItembarcode) 
    
      # Поиск в справочнике товаров
#      @TsdInventtables = TsdItembarcode.find(:all )  
#      count = 0
#      
#      @TsdInventtables.each do |basket|
#        count = count.to_i + 1
#      end    
#      
#      Alert.show_popup(
#          :message=> "TsdItembarcode_0 |" + count.to_s,
#          :title=>"Ошибка",
#          :buttons => ["Ok"]
#       )     
      
      #Rhom::Rhom.database_full_reset
      
#      Rho::RhoUtils.load_offline_data(['TsdItembarcode'], 'spec')      
        
#      @accts = TsdItembarcode.find_by_sql("DELETE from TsdItembarcode")   
#
#      ff = File.new("C:\\1\\Out.txt")             
#  

      # Поиск в справочнике товаров
#      @TsdInventtables = TsdItembarcode.find(:all )  
#      count = 0
#      
#      @TsdInventtables.each do |basket|
#        count = count.to_i + 1
#      end    
#      
#      Alert.show_popup(
#          :message=> "TsdItembarcode_1 |" + count.to_s,
#          :title=>"Ошибка",
#          :buttons => ["Ok"]
#       )             
#        
#      Alert.show_popup(
#          :message=> 'Begin',
#          :title=>"Внимание",
#          :buttons => ["Ok"]
#       )         
#      
#       
#        ff.each do |line|
#          @accts = TsdItembarcode.find_by_sql(line)        
#        end   
#      
#      ff.close
#        
#      Alert.show_popup(
#        
#          :message=> 'End',
#          :title=>"Внимание",
#          :buttons => ["Ok"]
#       )        
       
  
      
   Rhom::Rhom.database_full_reset
   Rhom::Rhom.database_fullclient_reset_and_logout
   
#	
#      TsdLog.delete_all()
#	  TsdInventlocation.delete_all()
#	  TsdUserinfo.delete_all()
#	
#	  TsdInventprice.delete_all()
#	  TsdInventsum.delete_all()
#	  TsdInventtable.delete_all()
#	  TsdItembarcode.delete_all()
	
#	  count = 290000
#	  
#	  while not count.to_i == 0
#      TsdInventtable.create("ItemId" => '123456', "ItemName" => 'ABCDEF', "VendId" => '123456', "VendName" => 'ABCDEF')
#	    count = count.to_i - 1
#	  end

#    db = Rho::Database.new(Rho::Application.databaseFilePath('app'),'app');  
#    db.executeBatchSql("insert into TsdInventtable (ItemId) values ('1')")
      
#      db = ::Rho::RHO.get_src_db('TsdInventtable')

#          data = {
#            :ItemId => '1', 
#            :ItemName => '1',
#            :VendId => '1',
#            :VendName => '1' 
#          } 
#
#          TsdInventtable.create(data)
   
  
      #db = Rho::RHO.get_src_db("TsdInventtable")
     
 #     @accts = TsdInventtable.find_by_sql("INSERT INTO TsdInventtable (ItemId, ItemName, VendId, VendName ) values ('1000','1','1','1')")
#      @accts = TsdInventtable.find(:first,     :conditions => { 
#      {
#        :name => "ItemId", 
#        :op => "IN" 
#      } => '1000'                
#      })
            
      #@accts = TsdInventtable.find_by_sql('SELECT * FROM TsdInventtable')
      #db.execute_sql("INSERT INTO TsdInventtable (ItemId, ItemName, VendId, VendName ) values ('1','1','1','1')")
      # INSERT INTO TsdInventtable (ItemId, ItemName, VendId, VendName ) values ('1','1','1','1')
      
      #db.execute_sql("select * from TsdInventtable")
    
#         count = 1000
#         
##         while not count.to_i == 0
##           @accts = TsdInventtable.find_by_sql("INSERT INTO TsdInventtable (ItemId, ItemName, VendId, VendName ) values ('" + count.to_s + "','100','1','1')")
##           count = count.to_i - 1
##         end      
#
#      @accts = TsdInventtabletmp.find_by_sql("INSERT INTO TsdInventtabletmp (ItemId, ItemName, VendId, VendName ) values ('1','100','1','1')")
#         
#      #@accts = TsdInventtable.find_by_sql("INSERT INTO TsdInventtable (ItemId, ItemName, VendId, VendName ) values ('1','100','1','1'); ")
#      @accts = TsdInventtable.find_by_sql("INSERT INTO TsdInventtable (ItemId, ItemName, VendId, VendName ) select ItemId, ItemName, VendId, VendName from TsdInventtabletmp")
#         
#
#                     
#	  count = 0
#	  
#	  @TsdInventtables = TsdInventtable.find(:all)
#	  
#      @TsdInventtables.each do |row|
#        count = count.to_i + 1
#      end
#	  	  
#      Alert.show_popup(
#          :message=> count,
#          :title=>"Внимание",
#          :buttons => ["Ok"]
#       )  	  
	  
#      AWSBasket.delete_all()
#	  AWSBaskettmp.delete_all()
#	  AWSBasketselect.delete_all()
#	
#	  TsdReceiptjour.delete_all()
#      TsdReceiptline.delete_all()	
#	  TsdReceiptjourselect.delete_all()
#      TsdReceiptlineselect.delete_all()
#	  TsdReceiptjourtmp.delete_all()
#      TsdReceiptlinetmp.delete_all()
#	
#	  TsdTsdInventcountjour.delete_all()
#      TsdInventcountline.delete_all()	
#      TsdTsdInventcountjourselect.delete_all()
#      TsdInventcountlineselect.delete_all()
#	  TsdTsdInventcountjourtmp.delete_all()
#      TsdInventcountlinetmp.delete_all()
	  
      WebView.navigate Rho::RhoConfig.start_path
    end
  end
  
  def Sync_
    if !(SyncEngine::logged_in > 0)
      SyncEngine.login("1", "1", (url_for :action => :login_callback) )       
    end 
    SyncEngine.dosync_source(TsdLog)      
  end
  
  #Загрузка данных справочника магазинов, пользователей,
  def dnload_location_user             
      # Магазины  
      #TsdInventlocation.delete_all()       
    
    #SyncEngine.dosync()

#    @TsdInventlocations = TsdInventlocation.find(:all)    
#      @TsdInventlocations.each do |row|
#        Alert.show_popup(
#            :message=> row,
#            :title=>"Внимание",
#            :buttons => ["Ok"]
#         )  
#      end   
      
#    @TsdInventlocations = TsdInventtable.find(:all)    
#      @TsdInventlocations.each do |row|
#        Alert.show_popup(
#            :message=> row,
#            :title=>"Внимание",
#            :buttons => ["Ok"]
#         )  
#      end
#
#    @TsdInventlocations = TsdInventprice.find(:all)      
#    @TsdInventlocations.each do |row|
#      Alert.show_popup(
#          :message=> row,
#          :title=>"Внимание",
#          :buttons => ["Ok"]
#       )  
#    end
#    
#    @TsdInventlocations = TsdInventsum.find(:all)    
#    @TsdInventlocations.each do |row|
#      Alert.show_popup(
#          :message=> row,
#          :title=>"Внимание",
#          :buttons => ["Ok"]
#       )  
#    end          

#        @TsdInventlocations = TsdLog.find(:all)    
#        @TsdInventlocations.each do |row|
#          Alert.show_popup(
#              :message=> row,
#              :title=>"Внимание",
#              :buttons => ["Ok"]
#           )  
#        end          
#                
#      SyncEngine.login("1", "1", (url_for :action => :login_callback) )
#      SyncEngine.dosync
#      SyncEngine.logout
     
#      fileName_i = File.join(Rho::RhoApplication::get_base_app_path(), '/public/TSD_InventLocation.txt')
#      lines_i = File.read(fileName_i)
#      jsonContent_i = Rho::JSON.parse(lines_i)
#      jsonContent_i.each {
#        |json|
#        TsdInventlocation.create("InventLocationId" => json['InventLocationId'], "InventLoationName" => json['InventLoationName'])
#      }
          
      # Пользователи
#      TsdUserinfo.delete_all()
    
#      fileName_i = File.join(Rho::RhoApplication::get_base_app_path(), '/public/TSD_UserInfo.txt')
#      lines_i = File.read(fileName_i)
#      jsonContent_i = Rho::JSON.parse(lines_i)
#      jsonContent_i.each {
#        |json|
#        TsdUserinfo.create("UserId" => json['UserId'],
#                            "UserName" => json['UserName'],
#                            "InventLocationId" => json['InventLocationId'],
#                            "Password" => json['Password'],
#                            "SetPassword" => json['SetPassword'])
#      }    

  end

  #Загрузка системных переменных
  def dnload_sysvar      
      # Системные переменные            
      @SysVars = SysVar.find(
      :first,
      :conditions => { 
        {
          :name => "Var", 
          :op => "IN" 
        } => "Last_Location" 
        } 
       )  
      
      if (!@SysVars)
        SysVar.create("Var" => "Last_Location", "Val" => "")
      else
        $Last_loc = @SysVars.Val    
      end  
      
      
      fileName_i = File.join(Rho::RhoApplication::get_base_app_path(), '/public/SysVar.txt')
      lines_i = File.read(fileName_i)
      jsonContent_i = Rho::JSON.parse(lines_i)
      jsonContent_i.each {
        |json|
        if (json["Var"] == "Device_id")
          @SysVarib = SysVar.find(
          :first,
          :conditions => { 
            {
              :name => "Var", 
              :op => "IN" 
            } => "Device_id" 
            } 
           )  
          
          if (!@SysVarib)           
            SysVar.create("Var" => json["Var"], "Val" => json["Val"])
          else
            @SysVarib.update_attributes({"Val" => json["Val"]})  
          end
          
          $device_id = json["Val"]
        end  
      }      
  end
     
end

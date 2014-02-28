# coding: utf-8

class TsdInventcountlineselect < SourceAdapter
  def initialize(source) 
    f = File.new(Dir.pwd + "/settings/config.txt")
    i = 0
    f.each do |line|
      if (i.to_i == 0)         
        @username = line.chop
      end
      if (i.to_i == 1) 
        @password = line.chop
      end      
      if (i.to_i == 2) 
        @host = line.chop
      end      
      if (i.to_i == 3) 
        @database = line.chop
      end
      if (i.to_i == 4) 
        @port = line.chop
      end      
      i = i.to_i + 1
    end
    f.close                           
            
    @client = TinyTds::Client.new(:username => @username, :password => @password, :database => @database, :host => @host, :port => @port) 
      
    super(source)
  end
 
  def uncode_str (str)
    ret = str
    
    ret = ret.gsub("%A","А");
    ret = ret.gsub("%B","Б");
    ret = ret.gsub("%C","В");
    ret = ret.gsub("%D","Г");
    ret = ret.gsub("%E","Д");
    ret = ret.gsub("%F","Е");
    ret = ret.gsub("%J","Ё");
    ret = ret.gsub("%H","Ж");
    ret = ret.gsub("%I","З");
    ret = ret.gsub("%J","И");
    ret = ret.gsub("%K","К");
    ret = ret.gsub("%L","Л");
    ret = ret.gsub("%M","М");
    ret = ret.gsub("%N","Н");
    ret = ret.gsub("%O","О");   
    ret = ret.gsub("%P","П");
    ret = ret.gsub("%Q","Р");
    ret = ret.gsub("%R","С");
    ret = ret.gsub("%S","Т");    
    ret = ret.gsub("%T","У");
    ret = ret.gsub("%U","Ф");
    ret = ret.gsub("%V","Х");
    ret = ret.gsub("%X","Т");
    ret = ret.gsub("%`","Ц");
    ret = ret.gsub("%~","Ч");
    ret = ret.gsub("%!","Ш");
    ret = ret.gsub("%@","Щ");
    ret = ret.gsub("%#","ь");
    ret = ret.gsub("%№","Ъ");
    ret = ret.gsub("%$","Э");
    ret = ret.gsub("%;","Ю");
    ret = ret.gsub("%:","Я");

    ret = ret.gsub("[A","а");
    ret = ret.gsub("[B","б");
    ret = ret.gsub("[C","в");
    ret = ret.gsub("[D","г");
    ret = ret.gsub("[E","д");
    ret = ret.gsub("[F","е");
    ret = ret.gsub("[J","ё");
    ret = ret.gsub("[H","ж");
    ret = ret.gsub("[I","з");
    ret = ret.gsub("[J","и");
    ret = ret.gsub("[K","к");
    ret = ret.gsub("[L","л");
    ret = ret.gsub("[M","м");
    ret = ret.gsub("[N","н");
    ret = ret.gsub("[O","о");   
    ret = ret.gsub("[P","п");
    ret = ret.gsub("[Q","р");
    ret = ret.gsub("[R","с");
    ret = ret.gsub("[S","т");    
    ret = ret.gsub("[T","у");
    ret = ret.gsub("[U","ф");
    ret = ret.gsub("[V","х");
    ret = ret.gsub("[X","т");
    ret = ret.gsub("[`","ц");
    ret = ret.gsub("[~","ч");
    ret = ret.gsub("[!","ш");
    ret = ret.gsub("[@","щ");
    ret = ret.gsub("[#","ь");
    ret = ret.gsub("[№","ъ");
    ret = ret.gsub("[$","э");
    ret = ret.gsub("[;","ю");
    ret = ret.gsub("[:","я");    
        
    return ret
  end  
  
  def login
    # TODO: Login to your data source here if necessary
  end
 
  def query(params=nil)
      puts "Call RecJourLinesSelect Query"
      
    if (params['param2'] == nil) 
      ret = params['param1']
      
#      ret = ret.gsub("%A","А");
#      ret = ret.gsub("%B","Б");
#      ret = ret.gsub("%C","В");
#      ret = ret.gsub("%D","Г");
#      ret = ret.gsub("%E","Д");
#      ret = ret.gsub("%F","Е");
#      ret = ret.gsub("%J","Ё");
#      ret = ret.gsub("%H","Ж");
#      ret = ret.gsub("%I","З");
#      ret = ret.gsub("%J","И");
#      ret = ret.gsub("%K","К");
#      ret = ret.gsub("%L","Л");
#      ret = ret.gsub("%M","М");
#      ret = ret.gsub("%N","Н");
#      ret = ret.gsub("%O","О");   
#      ret = ret.gsub("%P","П");
#      ret = ret.gsub("%Q","Р");
#      ret = ret.gsub("%R","С");
#      ret = ret.gsub("%S","Т");    
#      ret = ret.gsub("%T","У");
#      ret = ret.gsub("%U","Ф");
#      ret = ret.gsub("%V","Х");
#      ret = ret.gsub("%X","Т");
#      ret = ret.gsub("%`","Ц");
#      ret = ret.gsub("%~","Ч");
#      ret = ret.gsub("%!","Ш");
#      ret = ret.gsub("%@","Щ");
#      ret = ret.gsub("%#","ь");
#      ret = ret.gsub("%№","Ъ");
#      ret = ret.gsub("%$","Э");
#      ret = ret.gsub("%;","Ю");
#      ret = ret.gsub("%:","Я");
#  
#      ret = ret.gsub("[A","а");
#      ret = ret.gsub("[B","б");
#      ret = ret.gsub("[C","в");
#      ret = ret.gsub("[D","г");
#      ret = ret.gsub("[E","д");
#      ret = ret.gsub("[F","е");
#      ret = ret.gsub("[J","ё");
#      ret = ret.gsub("[H","ж");
#      ret = ret.gsub("[I","з");
#      ret = ret.gsub("[J","и");
#      ret = ret.gsub("[K","к");
#      ret = ret.gsub("[L","л");
#      ret = ret.gsub("[M","м");
#      ret = ret.gsub("[N","н");
#      ret = ret.gsub("[O","о");   
#      ret = ret.gsub("[P","п");
#      ret = ret.gsub("[Q","р");
#      ret = ret.gsub("[R","с");
#      ret = ret.gsub("[S","т");    
#      ret = ret.gsub("[T","у");
#      ret = ret.gsub("[U","ф");
#      ret = ret.gsub("[V","х");
#      ret = ret.gsub("[X","т");
#      ret = ret.gsub("[`","ц");
#      ret = ret.gsub("[~","ч");
#      ret = ret.gsub("[!","ш");
#      ret = ret.gsub("[@","щ");
#      ret = ret.gsub("[#","ь");
#      ret = ret.gsub("[№","ъ");
#      ret = ret.gsub("[$","э");
#      ret = ret.gsub("[;","ю");
#      ret = ret.gsub("[:","я");  
      
      res = @client.execute("SELECT [JourId]
      ,[ItemId]
      ,[ItemBarCode]
      ,[InventSizeId]
      ,CAST([CountedQty] AS INT) AS CountedQty 
    FROM [TSD_InventCountLine] WHERE [JourId] like '%" + ret.to_s + "'")      
    else
      res = @client.execute("SELECT [JourId]
      ,[ItemId]
      ,[ItemBarCode]
      ,[InventSizeId]
      ,CAST([CountedQty] AS INT) AS CountedQty 
    FROM [TSD_InventCountLine] WHERE [JourId] IN 
    (SELECT [JourId] FROM [TSD_InventCountJour] WHERE [InventLocationId] = '" + params['param1'].to_s + "' AND [Deleted] = 0)")      
    end   
      
#    begin  
#      tmp = params['param2'].to_s
#      res = @client.execute("SELECT [JourId]
#      ,[ItemId]
#      ,[ItemBarCode]
#      ,[InventSizeId]
#      ,[CountedQty]
#    FROM [TSD_InventCountLine] WHERE [JourId] IN 
#    (SELECT [JourId] FROM [TSD_InventCountJour] WHERE [InventLocationId] = '" + params['param1'].to_s + "' AND [Deleted] = 0)")
#      
##      res = @client.execute("SELECT [JourId]
##      ,[ItemId]
##      ,[ItemBarCode]
##      ,[InventSizeId]
##      ,[CountedQty]
##    FROM [TSD_InventCountLine] WHERE [JourId] IN 
##    (SELECT [JourId] FROM [TSD_InventCountJour] WHERE [InventLocationId] = '" + params['param1'].to_s + "' AND [JourDate] = CONVERT(DATETIME, '" + params['param2'].to_s + "', 126) AND [Deleted] = 0)")
#    rescue  
#      res = @client.execute("SELECT [JourId]
#      ,[ItemId]
#      ,[ItemBarCode]
#      ,[InventSizeId]
#      ,[CountedQty]
#    FROM [TSD_InventCountLine] WHERE [JourId] = '" + params['param1'].to_s + "'")
#    end      
           
    @result={}
                 
    res.each do |row|
      inventlocation = {} 
      inventlocation["JourId"] = row["JourId"]
      inventlocation["ItemId"] = row["ItemId"]
      inventlocation["InventSizeId"] = row["InventSizeId"]
      inventlocation["ItemBarCode"] = row["ItemBarCode"]
      inventlocation["CountedQty"] = row["CountedQty"]                     
      @result[row["JourId"].to_s + row["ItemId"].to_s + row["InventSizeId"].to_s] = inventlocation                             
    end 
  end
 
  def sync
    super
  end
 
  def create(create_hash)
  end
 
  def update(update_hash)
  end
 
  def delete(delete_hash)
  end
 
  def logoff
  end
end
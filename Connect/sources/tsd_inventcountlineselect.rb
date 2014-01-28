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
 
  def login
    # TODO: Login to your data source here if necessary
  end
 
  def query(params=nil)
      puts "Call RecJourLinesSelect Query"
      
    if (params['param2'] == nil) 
      res = @client.execute("SELECT [JourId]
      ,[ItemId]
      ,[ItemBarCode]
      ,[InventSizeId]
      ,CAST([CountedQty] AS INT) AS CountedQty 
    FROM [TSD_InventCountLine] WHERE [JourId] = '" + params['param1'].to_s + "'")      
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
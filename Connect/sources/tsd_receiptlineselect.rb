# coding: utf-8

class TsdReceiptlineselect < SourceAdapter
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
      
#    begin  
#      res = @client.execute("SELECT [JourId]
#      ,[ItemId]
#      ,[InventSizeId]
#      ,[OrderPrice]
#      ,[OrderedQty]
#      ,[ReceivedQty]
#    FROM [TSD_ReceiptLine] WHERE [JourId] IN 
#    (SELECT [JourId] FROM [TSD_ReceiptJour] WHERE [InventLocationId] = '" + params['param1'].to_s + "' AND [ShipDate] = CONVERT(DATETIME, '" + params['param2'].to_s + "', 126) AND [Deleted] = 0)")
#    rescue  
#      res = @client.execute("SELECT [JourId]
#      ,[ItemId]
#      ,[InventSizeId]
#      ,[OrderPrice]
#      ,[OrderedQty]
#      ,[ReceivedQty]
#    FROM [TSD_ReceiptLine] WHERE [JourId] = '" + params['param1'].to_s + "'")
#    end  
    
    par = params['param1'].to_s
    
    if (params['param2'] == nil)
      res = @client.execute("SELECT [JourId]
      ,[ItemId]
      ,[InventSizeId]
      ,CAST([OrderPrice] AS varchar(28)) AS OrderPrice
      ,CAST([OrderedQty] AS INT) AS OrderedQty 
      ,CAST([ReceivedQty] AS INT) AS ReceivedQty 
    FROM [TSD_ReceiptLine] WHERE [JourId] like '%" + par.to_s + "'")
    else
      res = @client.execute("SELECT [JourId]
      ,[ItemId]
      ,[InventSizeId]
      ,CAST([OrderPrice] AS varchar(28)) AS OrderPrice
      ,CAST([OrderedQty] AS INT) AS OrderedQty 
      ,CAST([ReceivedQty] AS INT) AS ReceivedQty 
    FROM [TSD_ReceiptLine] WHERE [JourId] IN 
    (SELECT [JourId] FROM [TSD_ReceiptJour] WHERE [InventLocationId] = '" + params['param1'].to_s + "' AND [ShipDate] = CONVERT(DATETIME, '" + params['param2'].to_s + "', 126) AND [Deleted] = 0)")
    end      
           
    @result={}
                 
    res.each do |row|
      inventlocation = {} 
       puts row
      inventlocation["JourId"] = row["JourId"]
      inventlocation["ItemId"] = row["ItemId"]
      inventlocation["InventSizeId"] = row["InventSizeId"]
      inventlocation["OrderPrice"] = row["OrderPrice"]
      inventlocation["OrderedQty"] = row["OrderedQty"]
      inventlocation["ReceivedQty"] = row["ReceivedQty"]                      
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
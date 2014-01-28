class TsdInventcountjourselect < SourceAdapter
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
      puts "Call InventCountSelect Query"
     
    if (params['param2'] == nil)
      res = @client.execute("SELECT [JourId]
      ,[InventLocationId]
      ,[JourDescription]
      ,CONVERT(char(10), [JourDate],126) as [JourDate]
      ,CAST([Deleted] AS INT) AS Deleted
      ,CAST(ISNULL([Imported],0) AS INT) AS Imported
    FROM [TSD_InventCountJour] WHERE [JourId] = '" + params['param1'].to_s + "'")
    else
      res = @client.execute("SELECT [JourId]
      ,[InventLocationId]
      ,[JourDescription]
      ,CONVERT(char(10), [JourDate],126) as [JourDate]
      ,CAST([Deleted] AS INT) AS Deleted
      ,CAST(ISNULL([Imported],0) AS INT) AS Imported
      FROM [TSD_InventCountJour] WHERE [InventLocationId] = '" + params['param1'].to_s + "' AND [Deleted] = 0")    
    end  
      
#    begin
#      tmp =  params['param2'].to_s
#      res = @client.execute("SELECT [JourId]
#      ,[InventLocationId]
#      ,[JourDescription]
#      ,CONVERT(char(10), [JourDate],126) as [JourDate]
#      ,[Deleted]
#      ,[Imported]
#    FROM [TSD_InventCountJour] WHERE [InventLocationId] = '" + params['param1'].to_s + "' AND [Deleted] = 0")    
#
##      res = @client.execute("SELECT [JourId]
##      ,[InventLocationId]
##      ,[JourDescription]
##      ,CONVERT(char(10), [JourDate],126) as [JourDate]
##      ,[Deleted]
##      ,[Imported]
##    FROM [TSD_InventCountJour] WHERE [InventLocationId] = '" + params['param1'].to_s + "' AND [JourDate] = CONVERT(DATETIME, '" + params['param2'].to_s + "', 126) AND [Deleted] = 0")    
#    rescue  
#      res = @client.execute("SELECT [JourId]
#      ,[InventLocationId]
#      ,[JourDescription]
#      ,CONVERT(char(10), [JourDate],126) as [JourDate]
#      ,[Deleted]
#      ,[Imported]
#    FROM [TSD_InventCountJour] WHERE [JourId] = '" + params['param1'].to_s + "'")
#    end      
           
    @result={}
                 
    res.each do |row|
      inventlocation = {}
      inventlocation["JourId"] = row["JourId"]
      inventlocation["InventLocationId"] = row["InventLocationId"]
      inventlocation["JourDescription"] = row["JourDescription"]
      inventlocation["JourDate"] = row["JourDate"]
      inventlocation["Deleted"] = row["Deleted"]                      
      inventlocation["Imported"] = row["Imported"]                                      
      @result[row["JourId"].to_s] = inventlocation                             
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
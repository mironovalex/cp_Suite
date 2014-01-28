class TsdInventsum < SourceAdapter
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
    puts "Call InventSum Query"
    
    #res = @client.execute("SELECT [InventLocationId],[ItemId],[InventSizeId],[VendCode],[AvailableQty],[OrderedQty] FROM [TSD_InventSum]")

    puts "SELECT [InventLocationId],[ItemId],[InventSizeId],[VendCode],CAST([AvailableQty] AS INT) AS AvailableQty,CAST([OrderedQty] AS INT) AS OrderedQty FROM [TSD_InventSum] WHERE [InventLocationId] = '" + params['param'].to_s + "'"
    
    begin  
      res = @client.execute("SELECT [InventLocationId],[ItemId],[InventSizeId],[VendCode],CAST([AvailableQty] AS INT) AS AvailableQty,CAST([OrderedQty] AS INT) AS OrderedQty FROM [TSD_InventSum] WHERE [InventLocationId] = '" + params['param'].to_s + "'")
    rescue  
      res = @client.execute("SELECT [InventLocationId],[ItemId],[InventSizeId],[VendCode],CAST([AvailableQty] AS INT) AS AvailableQty,CAST([OrderedQty] AS INT) AS OrderedQty FROM [TSD_InventSum]")          
    end      
    
    @result={}
      
    res.each do |row|
      inventlocation = {}
      inventlocation["InventLocationId"] = row["InventLocationId"]
      inventlocation["ItemId"] = row["ItemId"]
      inventlocation["InventSizeId"] = row["InventSizeId"]      
      inventlocation["VendCode"] = row["VendCode"]
      inventlocation["AvailableQty"] = row["AvailableQty"]
      inventlocation["OrderedQty"] = row["OrderedQty"]      
                                     
      @result[row["InventLocationId"].to_s + row["ItemId"].to_s + row["InventSizeId"] .to_s] = inventlocation                             
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
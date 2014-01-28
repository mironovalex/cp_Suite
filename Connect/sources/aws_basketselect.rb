class AWSBasketselect < SourceAdapter
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
    puts "Call BasketSelect Query"
  
    begin  
      res = @client.execute("SELECT [InventLocationId]
      ,[UserId]
      ,[ItemBarCode]
      ,[ItemId]
      ,[InventSizeId]
      ,[PrintCopies]
      ,[LineNum]
      ,[YellowLabel]
      FROM [AWSBasket] WHERE [InventLocationId] = '" + params['param1'].to_s + "' AND [UserId] = '" + params['param2'].to_s + "'")
    rescue  
      res = @client.execute("SELECT [InventLocationId]
      ,[UserId]
      ,[ItemBarCode]
      ,[ItemId]
      ,[InventSizeId]
      ,[PrintCopies]
      ,[LineNum]
      ,[YellowLabel]
      FROM [AWSBasket]")
    end      
           
    @result={}
                 
    res.each do |row|
      inventlocation = {}
      inventlocation["InventLocationId"] = row["InventLocationId"]
      inventlocation["UserId"] = row["UserId"]
      inventlocation["ItemBarCode"] = row["ItemBarCode"]
      inventlocation["ItemId"] = row["ItemId"]
      inventlocation["InventSizeId"] = row["InventSizeId"]
      inventlocation["PrintCopies"] = row["PrintCopies"]
      inventlocation["LineNum"] = row["LineNum"]                      
      inventlocation["YellowLabel"] = row["YellowLabel"]                                      
      @result[row["InventLocationId"].to_s + row["UserId"].to_s + row["ItemBarCode"].to_s + row["ItemId"].to_s + row["InventSizeId"].to_s + row["LineNum"].to_s] = inventlocation                             
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
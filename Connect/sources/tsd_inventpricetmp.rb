class TsdInventpricetmp < SourceAdapter
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
    puts "Call InventPrice Query"
    
    puts
    puts params['param2'].to_s
    puts
        
    begin
      res = @client.execute("select TOP 5000 [InventLocationId],[ItemId],[InventSizeId],CAST([RetailPrice] AS varchar(28)) AS RetailPrice,CAST([SalesPrice] AS varchar(28)) AS SalesPrice,CAST([SalesDiscount] AS varchar(28)) AS SalesDiscount,[YellowLabel],
           [InventLocationId]+'#'+[ItemId]+'#'+[InventSizeId] B 
      FROM [TSD_InventPrice] where 
              [InventLocationId] = '" + params['param'].to_s + "' and  
              [InventSourceType] = '" + params['param3'].to_s + "' and  
              [InventLocationId]+'#'+[ItemId]+'#'+[InventSizeId] > 
          (select coalesce(max(T.A),'') from 
          (select TOP " + params['param2'].to_s + " 
            [InventLocationId]+'#'+[ItemId]+'#'+[InventSizeId] A from TSD_Inventprice 
            where
            [InventSourceType] = '" + params['param3'].to_s + "' and 
            [InventLocationId] = '" + params['param'].to_s + "' order by A) T)       
      order by B")
              
      #res = @client.execute("SELECT [InventLocationId],[ItemId],[InventSizeId],CAST([RetailPrice] AS varchar(10)) AS RetailPrice,CAST([SalesPrice] AS varchar(10)) AS SalesPrice,[SalesDiscount],[YellowLabel] FROM [TSD_InventPrice] WHERE [InventLocationId] = '" + params['param'].to_s + "'")
    rescue  
      res = @client.execute("SELECT [InventLocationId],[ItemId],[InventSizeId],CAST([RetailPrice] AS varchar(28)) AS RetailPrice,CAST([SalesPrice] AS varchar(28)) AS SalesPrice,CAST([SalesDiscount] AS varchar(28)) AS SalesDiscount,[YellowLabel] FROM [TSD_InventPrice]")
    end      
    
    @result={}
      
    res.each do |row|
      inventlocation = {}
      inventlocation["InventLocationId"] = row["InventLocationId"]
      inventlocation["ItemId"] = row["ItemId"]
      inventlocation["InventSizeId"] = row["InventSizeId"]      
      inventlocation["RetailPrice"] = row["RetailPrice"]
      inventlocation["SalesPrice"] = row["SalesPrice"]
      inventlocation["SalesDiscount"] = row["SalesDiscount"]      
      inventlocation["YellowLabel"] = row["YellowLabel"]
                                     
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
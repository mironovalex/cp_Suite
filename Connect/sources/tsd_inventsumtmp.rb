class TsdInventsumtmp < SourceAdapter
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
    puts "Call InventSumtmp Query"
    
    puts
    puts params['param2'].to_s
    puts    
    
    #res = @client.execute("SELECT [InventLocationId],[ItemId],[InventSizeId],[VendCode],[AvailableQty],[OrderedQty] FROM [TSD_InventSum]")

    begin
      res = @client.execute(
      "select TOP 5000  
        [InventLocationId],[ItemId],[InventSizeId],
        (select coalesce(max(TT.VendCode),'') from TSD_Inventtable TT where TT.ItemId = TS.ItemId and TT.InventLocationId = TS.InventLocationId) [VendCode],
        [AvailableQty],[OrderedQty], 
        [InventLocationId]+'#'+[ItemId]+'#'+[InventSizeId] B 
      FROM [TSD_InventSum] TS where 
              [InventLocationId] = '" + params['param'].to_s + "' and
              [InventSourceType] = '" + params['param3'].to_s + "' and   
              [InventLocationId]+'#'+[ItemId]+'#'+[InventSizeId] > 
          (select coalesce(max(T.A),'') from 
          (select TOP " + params['param2'].to_s + " 
            [InventLocationId]+'#'+[ItemId]+'#'+[InventSizeId] A from TSD_Inventsum where 
              [InventLocationId] = '" + params['param'].to_s + "' and 
              [InventSourceType] = '" + params['param3'].to_s + "' 
          order by A) T)       
      order by B")
  
      #res = @client.execute("SELECT [InventLocationId],[ItemId],[InventSizeId],[VendCode],[AvailableQty],[OrderedQty] FROM [TSD_InventSum] WHERE [InventLocationId] = '" + params['param'].to_s + "'")
    rescue  
      res = @client.execute("SELECT [InventLocationId],[ItemId],[InventSizeId],[VendCode],[AvailableQty],[OrderedQty] FROM [TSD_InventSum]")          
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
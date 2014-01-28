class TsdItembarcodetemp < SourceAdapter
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
    puts "Call InventBarcodetmp Query"
    
    puts
    puts params['param2'].to_s
    puts
    
    #puts "select TOP 1000 [ItemId],[InventSizeId],[ItemBarCode] from [TSD_ItemBarCode] where ItemBarCode > (select coalesce(max(T.ItemBarCode),'') from (select TOP " + params['param'].to_s + " ItemBarCode from [TSD_ItemBarCode] order by ItemBarCode) T) order by ItemBarCode"
    
    res = @client.execute(
        "select TOP 5000 [ItemId],[InventSizeId],[ItemBarCode] 
         from [TSD_ItemBarCode] 
         where [InventLocationId] = '" + params['param'].to_s + "' and 
               [InventSourceType] = '" + params['param3'].to_s + "' and 
               [ItemBarCode] > 
             (select coalesce(max(T.ItemBarCode),'') from 
                 (select TOP " + params['param2'].to_s + " ItemBarCode 
                  from [TSD_ItemBarCode] 
                  where [InventLocationId] = '" + params['param'].to_s + "' and
                        [InventSourceType] = '" + params['param3'].to_s + "'
              order by ItemBarCode) T) 
         order by ItemBarCode")
    
    @result={}
      
    res.each do |row|
      inventlocation = {}
      inventlocation["ItemId"] = row["ItemId"]
      inventlocation["InventSizeId"] = row["InventSizeId"]
      inventlocation["ItemBarCode"] = row["ItemBarCode"]      
                                     
      @result[row["ItemBarCode"].to_s] = inventlocation                             
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
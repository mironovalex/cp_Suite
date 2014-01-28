

class TsdItembarcode < SourceAdapter
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
    puts "Call InventBarcode Query"
    
    res = @client.execute("SELECT [ItemId],[InventSizeId],[ItemBarCode] FROM [TSD_ItemBarCode]")
    
    @result={}
            
#    ff = File.new("C:\\Projects\\RHO\\workspace\\cp_Suite_ship\\spec\\fixtures\\TsdItembarcode.txt","w")
#            
#    ff.puts("ItemId|InventSizeId|ItemBarCode")
    
    
    res.each do |row|
      inventlocation = {}
      inventlocation["ItemId"] = row["ItemId"]
      inventlocation["InventSizeId"] = row["InventSizeId"]
      inventlocation["ItemBarCode"] = row["ItemBarCode"]      
       
#      ff.puts(row["ItemId"].to_s+"|"+row["InventSizeId"].to_s+"|"+row["ItemBarCode"].to_s+"|")
      #ff.puts("Input into TsdItembarcode (ItemId,InventSizeId,ItemBarCode) values (")
                                    
      @result[row["ItemBarCode"].to_s] = inventlocation  
        
                          
    end  
    
#    ff.close
    
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
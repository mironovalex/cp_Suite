class TsdInventtable < SourceAdapter
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
    puts "Call InventTable Query"
    
    res = @client.execute("SELECT [ItemId],[ItemName],[VendId],[VendName] FROM [TSD_InventTable]")
    
    @result={}
      
    count = 0  
      
    res.each do |row|
      inventlocation = {}
      inventlocation["ItemId"] = row["ItemId"]
      inventlocation["ItemName"] = row["ItemName"]
      inventlocation["VendId"] = row["VendId"]      
      inventlocation["VendName"] = row["VendName"]                
             
       count = count.to_i + 1
        
      @result[row["ItemId"].to_s] = inventlocation                             
    end  
    
  puts count
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
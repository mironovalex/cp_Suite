class TsdInventtabletmp < SourceAdapter
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
    puts "Call InventTabletmp Query"
    
    puts
    puts params['param2'].to_s
    puts    
    
    res = @client.execute(
      "select distinct TOP 5000 [ItemId],[ItemName],[VendId],[VendName] 
       from TSD_Inventtable 
       where [InventLocationId] = '" + params['param'].to_s + "' and 
             [InventSourceType] = '" + params['param3'].to_s + "' and 
             [ItemId] > 
           (select coalesce(max(T.ItemId),'') from 
               (select distinct TOP " + params['param2'].to_s + " ItemId 
                from TSD_Inventtable 
                where [InventLocationId] = '" + params['param'].to_s + "' and 
                      [InventSourceType] = '" + params['param3'].to_s + "' 
            order by ItemId) T) 
       order by ItemId")
    
    @result={}
      
#    count = 0  
      
    res.each do |row|
      inventlocation = {}
      inventlocation["ItemId"] = row["ItemId"]
      inventlocation["ItemName"] = row["ItemName"]
      inventlocation["VendId"] = row["VendId"]      
      inventlocation["VendName"] = row["VendName"]                
             
#       count = count.to_i + 1
        
      @result[row["ItemId"].to_s] = inventlocation                             
    end  
    
#  puts count
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
require 'json'
require 'rest_client'
require 'tiny_tds'

class TsdUserinfo < SourceAdapter
  
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
        @port 
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
    puts "Call User Query"
    
    res = @client.execute("SELECT [UserId],[UserName],[InventLocationId],[Password],CAST([SetPassword] AS INT) AS SetPassword FROM [TSD_UserInfo]")
    
    @result={}
      
    res.each do |row|
      rec = {}
      rec["UserId"] = row["UserId"]
      rec["UserName"] = row["UserName"]
      rec["InventLocationId"] = row["InventLocationId"]
      rec["Password"] = row["Password"]
      rec["SetPassword"] = row["SetPassword"]                
             
      #puts rec  
        
      @result[row["UserId"].to_s + row["InventLocationId"].to_s] = rec                             
    end  
  end
 
  def sync
    super
  end
 
  def create(create_hash)
  end
 
  def update(update_hash)
    puts 'Update Users'
    
    res = @client.execute("UPDATE [TSD_UserInfo] SET [Password] = '" + update_hash["Password"] + 
    "', [SetPassword] = '" + update_hash["SetPassword"] + "' WHERE [UserId] = '" + update_hash["UserId"] + 
    "' AND [InventLocationId] = '" + update_hash["InventLocationId"] + "'")

    res.do
  end
 
  def delete(delete_hash)
  end
 
  def logoff
  end
end
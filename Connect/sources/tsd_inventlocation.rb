require 'json'
require 'rest_client'
require 'tiny_tds'

class TsdInventlocation < SourceAdapter
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
  end
 
  def query(params=nil) 
    puts "Call Loc Query"
    
    res = @client.execute("SELECT [InventLocationId],[InventLocationName] FROM [TSD_InventLocation]")
    
    @result={}
      
    res.each do |row|
      inventlocation = {}
      inventlocation["InventLocationId"] = row["InventLocationId"]
      inventlocation["InventLoationName"] = row["InventLocationName"]       
             
      @result[row["InventLocationId"].to_s] = inventlocation                             
    end      
  end
 
  def sync
    super
  end
 
  def create(create_hash)
    puts "Call create"
  end
 
  def update(update_hash)
    puts "Call update"
  end
 
  def delete(delete_hash)
    puts "Call Delete"
  end
 
  def logoff
  end
end
class TsdInventcountjourtmp < SourceAdapter
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
  end
 
  def sync
    super
  end
 
  def create(create_hash)
    
    puts "CRE"
      res = @client.execute("DELETE FROM [TSD_InventCountLine] WHERE [JourId] = '" + create_hash["JourId"].to_s + "'")
      res.do  
  
      res = @client.execute("UPDATE [TSD_InventCountJour] SET [Imported] = 1 WHERE [JourId] = '" + create_hash["JourId"].to_s + "'")
      res.do
  end
 
  def update(update_hash)
  end
 
  def delete(delete_hash)
    puts "DEL"
    
    res = @client.execute("DELETE FROM [TSD_InventCountLine] WHERE [JourId] = '" + delete_hash["JourId"].to_s + "'")
    res.do  

    res = @client.execute("UPDATE [TSD_InventCountJour] SET [Imported] = 1 WHERE [JourId] = '" + delete_hash["JourId"].to_s + "'")
    res.do
  end
 
  def logoff
  end
end
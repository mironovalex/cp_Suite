class TsdInventcountlinetmp < SourceAdapter
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
    res = @client.execute("DELETE FROM [TSD_InventCountLine] WHERE 
    [JourId] = '" + create_hash["JourId"].to_s + "' AND 
    [ItemBarCode] = '" + create_hash["ItemBarCode"].to_s + "' AND 
    [ItemId] = '" + create_hash["ItemId"].to_s + "' AND 
    [InventSizeId] = '" + create_hash["InventSizeId"].to_s + "'")  
   
    res.do  
    
      res = @client.execute("INSERT INTO [TSD_InventCountLine] 
    ([JourId]
    ,[ItemBarCode]
    ,[ItemId]
    ,[InventSizeId]
    ,[CountedQty],[RecId])
   VALUES
    ('" + create_hash["JourId"].to_s + "'
    ,'" + create_hash["ItemBarCode"].to_s + "'
    ,'" + create_hash["ItemId"].to_s + "'
    ,'" + create_hash["InventSizeId"].to_s + "'
    ," + create_hash["CountedQty"].to_s + ", 1)")
	  
    res.insert 
  end
 
  def update(update_hash)    
    puts
    puts "update"
    puts   
  end
 
  def delete(delete_hash)        
   res = @client.execute("DELETE FROM [TSD_InventCountLine] WHERE 
   [JourId] = '" + delete_hash["JourId"].to_s + "' AND 
   [ItemBarCode] = '" + delete_hash["ItemBarCode"].to_s + "' AND 
   [ItemId] = '" + delete_hash["ItemId"].to_s + "' AND 
   [InventSizeId] = '" + delete_hash["InventSizeId"].to_s + "'")  
  
   res.do      
    
      res = @client.execute("INSERT INTO [TSD_InventCountLine] 
    ([JourId]
    ,[ItemBarCode]
    ,[ItemId]
    ,[InventSizeId]
    ,[CountedQty],[RecId])
   VALUES
    ('" + delete_hash["JourId"].to_s + "'
    ,'" + delete_hash["ItemBarCode"].to_s + "'
    ,'" + delete_hash["ItemId"].to_s + "'
    ,'" + delete_hash["InventSizeId"].to_s + "'
    ," + delete_hash["CountedQty"].to_s + ", 1)")
    
    res.do  
  end
 
  def logoff
  end
end
class AWSBaskettmp < SourceAdapter
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
  end
 
  def sync
    super
  end
 
  def create(create_hash)
    puts "Call Create Basket"          
    
    rez = @client.execute("DELETE FROM [AWSBasket] WHERE [InventLocationId] = '" + create_hash["InventLocationId"].to_s + 
      "' AND [UserId] = '" + create_hash["UserId"].to_s + "' AND [LineNum] >= " + create_hash["LineNum"].to_s )
    
    rez.do       
       
      var = ""     
      if (create_hash["YellowLabel"] = "")
        var = "0"
      else
        var = create_hash["YellowLabel"].to_s 
      end  
                
    rez = @client.execute("INSERT INTO [AWSBasket]
    ([InventLocationId]
    ,[UserId]
    ,[ItemBarCode]
    ,[ItemId]
    ,[InventSizeId]
    ,[PrintCopies]
    ,[LineNum]
    ,[YellowLabel],[RecId])
VALUES
    ('" + create_hash["InventLocationId"].to_s + "'
    ,'" + create_hash["UserId"].to_s + "'
    ,'" + create_hash["ItemBarCode"].to_s + "'
    ,'" + create_hash["ItemId"].to_s + "'
    ,'" + create_hash["InventSizeId"].to_s + "'
    ," + create_hash["PrintCopies"].to_s + "
    ," + create_hash["LineNum"].to_s + "
    ," + var.to_s + ", 1)") #create_hash["YellowLabel"].to_s
       
    rez.insert     
  end
 
  def update(update_hash)

  end
 
  def delete(delete_hash)
    puts "Call Del Basket"           
    
    rez = @client.execute("DELETE FROM [AWSBasket] WHERE [InventLocationId] = '" + delete_hash["InventLocationId"].to_s + 
      "' AND [UserId] = '" + delete_hash["UserId"].to_s + "' AND [LineNum] >= " + delete_hash["LineNum"].to_s )
    
    rez.do       
     
      var = ""     
      if (delete_hash["YellowLabel"] = "")
        var = "0"
      else
        var = delete_hash["YellowLabel"].to_s 
      end      
      
 puts
 puts "INSERT INTO [AWSBasket]
      ([InventLocationId]
      ,[UserId]
      ,[ItemBarCode]
      ,[ItemId]
      ,[InventSizeId]
      ,[PrintCopies]
      ,[LineNum]
      ,[YellowLabel],[RecId])
  VALUES
      ('" + delete_hash["InventLocationId"].to_s + "'
      ,'" + delete_hash["UserId"].to_s + "'
      ,'" + delete_hash["ItemBarCode"].to_s + "'
      ,'" + delete_hash["ItemId"].to_s + "'
      ,'" + delete_hash["InventSizeId"].to_s + "'
      ," + delete_hash["PrintCopies"].to_s + "
      ," + delete_hash["LineNum"].to_s + "
      ," + var.to_s + ", 1)"
 puts     
     
         
    rez = @client.execute("INSERT INTO [AWSBasket]
    ([InventLocationId]
    ,[UserId]
    ,[ItemBarCode]
    ,[ItemId]
    ,[InventSizeId]
    ,[PrintCopies]
    ,[LineNum]
    ,[YellowLabel],[RecId])
VALUES
    ('" + delete_hash["InventLocationId"].to_s + "'
    ,'" + delete_hash["UserId"].to_s + "'
    ,'" + delete_hash["ItemBarCode"].to_s + "'
    ,'" + delete_hash["ItemId"].to_s + "'
    ,'" + delete_hash["InventSizeId"].to_s + "'
    ," + delete_hash["PrintCopies"].to_s + "
    ," + delete_hash["LineNum"].to_s + "
    ," + var.to_s + ", 1)") #create_hash["YellowLabel"].to_s
       
    rez.insert  
  end
 
  def logoff
  end
end
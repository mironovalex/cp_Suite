class TsdLog < SourceAdapter
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
    
    #@client = TinyTds::Client.new(:username => 'sa', :password => '', :host => '10.39.3.200', :database => 'cp_suite')
    super(source)
  end
 
  def login
  end
 
  def query(params=nil)
  end
 
  def sync
    # Manipulate @result before it is saved, or save it 
    # yourself using the Rhoconnect::Store interface.
    # By default, super is called below which simply saves @result
    super
  end
 
  def create(create_hash)
    puts "Call Create Log"      
              
    rez = @client.execute("INSERT INTO [TSD_Log]
      ([UserId]
      ,[DeviceID]
      ,[Date]
      ,[Time]
      ,[Operation]
      ,[Status]
      ,[Comment_],[RecId])
     VALUES
      ('" + create_hash["UserId"].to_s + "',
       '" + create_hash["DeviceID"].to_s + "',
       CONVERT(DATETIME, '" + create_hash["Date"].to_s + "', 126),
       " + create_hash["Time"].to_s + ", 
       " + create_hash["Operation"].to_s + ",
       " + "0" + ",
       '" + create_hash["Comment"].to_s + "', 1)")
   
    rez.insert               
  end
  
  def update(update_hash)
  end
 
  def delete(delete_hash)
  end
 
  def logoff
  end
end
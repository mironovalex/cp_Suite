# The model has already been created by the framework, and extends Rhom::RhomObject
# You can add more methods here
class TsdInventtable
  include Rhom::FixedSchema#PropertyBag

  # Uncomment the following line to enable sync with TsdInventtable.
   enable :sync
  #enable :pass_through 
  #add model specifc code here
  set :sync_type, :bulk_only 
   
  property :ItemId, :string[20]
  property :ItemName, :string[140]
  property :VendId, :string[20]
  property :VendName, :string[140]   
      
end

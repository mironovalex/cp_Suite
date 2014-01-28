# The model has already been created by the framework, and extends Rhom::RhomObject
# You can add more methods here
class TsdInventsum
  include Rhom::FixedSchema#PropertyBag

  # Uncomment the following line to enable sync with TsdInventtable.
   enable :sync
  #enable :pass_through 
  #add model specifc code here
  set :sync_type, :bulk_sync_only 
  
  property :InventLocationId, :string[10]
  property :ItemId, :string[20]
  property :InventSizeId, :string[10]
  property :VendCode, :string[40]  
  property :AvailableQty, :integer
  property :OrderedQty, :integer  
end

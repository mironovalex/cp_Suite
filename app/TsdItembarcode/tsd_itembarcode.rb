# The model has already been created by the framework, and extends Rhom::RhomObject
# You can add more methods here
class TsdItembarcode
  include Rhom::FixedSchema#PropertyBag

  # Uncomment the following line to enable sync with TsdInventtable.
   enable :sync
  #enable :pass_through 
  #add model specifc code here
  set :sync_type, :bulk_only   
  
  property :ItemId, :string[20]
  property :InventSizeId, :string[10]
  property :ItemBarCode, :string[40]
end

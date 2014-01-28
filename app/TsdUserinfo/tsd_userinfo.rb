# The model has already been created by the framework, and extends Rhom::RhomObject
# You can add more methods here
class TsdUserinfo
  include Rhom::PropertyBag

  # Uncomment the following line to enable sync with TsdUserinfo.
   enable :sync
   #enable :pass_through    
   enable :full_update
  
  #add model specifc code here
end

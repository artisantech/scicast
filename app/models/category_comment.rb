class CategoryComment < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    body :text
    timestamps
  end
  
  belongs_to :category
  belongs_to :author, :class_name => "User", :creator => true
  
  attr_protected :category
  
  # --- Permissions --- #

  def create_permitted?
    return false unless author == acting_user
    acting_user.administrator? || acting_user.judge?
  end

  def update_permitted?
    false
  end

  def destroy_permitted?
    false
  end

  def view_permitted?(field)
    acting_user.administrator? || acting_user.judge?
  end

end

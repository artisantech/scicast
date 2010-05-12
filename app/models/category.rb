class Category < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    timestamps
  end
  
  has_many :judge_assignments
  has_many :judges, :through => :judge_assignments, :class_name => "User"
  
  belongs_to :tag
  
  def films
    Film.find_tagged_with(tag).tap { |films| films.origin = self; films.origin_attribute = :films }
  end
  
  def duplicate
    dup = Category.new :name => "Copy of #{name}"
    judges.each { |j| dup.judges << j }
    dup.save!
    dup
  end

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end
  
  def duplicate_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end

class User < ActiveRecord::Base

  hobo_user_model # Don't put anything above this

  fields do
    name          :string, :required, :unique
    email         :email_address, :login => true
    
    location    :string
    institution :string
    
    feedback :text
    
    administrator :boolean, :default => false
    timestamps
  end

  # This gives admin rights to the first sign-up.
  # Just remove it if you don't want that
  before_create { |user| user.administrator = true if !Rails.env.test? && count == 0 }
  
  attr_accessor :film_title, :team_name, :type => :string
  attr_accessor :film_description, :type => :text
  attr_accessor :file
  
  validates_presence_of :film_title, :film_description, :file, :team_name
  
  has_many :films
  
  after_create :create_film
  
  include Geocode
  
  # --- Signup lifecycle --- #

  lifecycle do

    state :active, :default => true

    create :signup, :available_to => "Guest",
           :params => [:name, :film_title, :file, :film_description, :team_name, :email, :password, :password_confirmation],
           :become => :active
             
    transition :request_password_reset, { :active => :active }, :new_key => true do
      UserMailer.deliver_forgot_password(self, lifecycle.key)
    end

    transition :reset_password, { :active => :active }, :available_to => :key_holder,
               :params => [ :password, :password_confirmation ]

  end
  
  def create_film
    films.create! :title => film_title, :description => film_description, :movie => file, :team_name => team_name
  end
  

  # --- Permissions --- #

  def create_permitted?
    false
  end

  def update_permitted?
    acting_user.administrator? || 
      (acting_user == self && only_changed?(:email, :crypted_password,
                                            :current_password, :password, :password_confirmation))
    # Note: crypted_password has attr_protected so although it is permitted to change, it cannot be changed
    # directly from a form submission.
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    new_record? || acting_user.administrator? || acting_user == self
  end

end

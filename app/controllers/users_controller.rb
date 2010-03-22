class UsersController < ApplicationController

  hobo_user_controller

  auto_actions :all, :except => [ :index, :new, :create ]
  
  index_action :after_signup
  
  def signup
    if logged_in?
      redirect_to current_user
    else
      creator_page_action(:signup)
    end
  end
  
  def do_signup
    do_creator_action :signup do
      redirect_to after_signup_users_url if valid?
    end
  end
  
  def do_activate
    do_transition_action :activate do
      if valid?
        flash[:notice] = "Your film has been submitted!"
        self.current_user = @this 
      end
    end
  end

end

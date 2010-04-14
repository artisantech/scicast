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
        redirect_to @this.films.first
        self.current_user = @this 
      else
        this.update_attribute :state, 'inactive' # workaround for hobo lifecycle bug
      end
    end
  end
  
  def forgot_password
    if request.post?
      user = model.find_by_email(params[:email_address]) and user.lifecycle.request_password_reset!(:nobody)
      render_tag :forgot_password_email_sent_page
    end
  end

end

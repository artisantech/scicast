class UsersController < ApplicationController

  hobo_user_controller

  auto_actions :all, :except => [ :index, :new, :create ]
  
  def signup
    if logged_in?
      redirect_to current_user
    else
      creator_page_action(:signup)
    end
  end

end

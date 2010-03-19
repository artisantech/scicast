class FilmsController < ApplicationController

  hobo_model_controller
  
  auto_actions_for :user, :create
  
  def create_for_user
    hobo_create do
      if valid?
        redirect_to current_user
      else
        @this = current_user
        render :template => "users/show"
      end
    end
  end

end

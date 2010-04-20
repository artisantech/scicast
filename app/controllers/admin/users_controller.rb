class Admin::UsersController < Admin::AdminSiteController

  hobo_model_controller

  auto_actions :all
  
  def create
    hobo_create do
      redirect_to @user.films.first, :edit if valid?
    end
  end

end

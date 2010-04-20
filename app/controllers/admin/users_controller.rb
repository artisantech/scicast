class Admin::UsersController < Admin::AdminSiteController

  hobo_model_controller

  auto_actions :all
  
  def index
    hobo_index User.apply_scopes(:search => [params[:search], :name, :email, :institution])
  end
    
  
  def create
    hobo_create do
      redirect_to @user.films.first, :edit if valid?
    end
  end

end

class Admin::UsersController < Admin::AdminSiteController

  hobo_model_controller

  auto_actions :all
  
  def index
    hobo_index User.apply_scopes(:search => [params[:search], :name, :email, :institution],
                                 :order_by => parse_sort_param(:name, :email, :institution))
  end
    
  
  def create
    hobo_create do
      if valid?
        @user.mark_created_by_admin!
        redirect_to @user.films.first, :edit
      end
    end
  end

end

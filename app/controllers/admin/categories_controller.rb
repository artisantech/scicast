class Admin::CategoriesController < Admin::AdminSiteController

  hobo_model_controller

  auto_actions :all, :except => [:new, :edit, :show]
  
  web_method :duplicate do
    this.duplicate
    redirect_to Category
  end
  
end

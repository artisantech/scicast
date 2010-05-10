class Admin::CategoriesController < Admin::AdminSiteController

  hobo_model_controller

  auto_actions :all, :except => [:new, :edit, :show]
  
end

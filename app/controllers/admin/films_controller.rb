class Admin::FilmsController < Admin::AdminSiteController

  hobo_model_controller

  auto_actions :index, :show, :edit, :update

end

class Judging::CategoriesController < Judging::JudgingSiteController

  hobo_model_controller

  auto_actions :show
  
  def index
    hobo_index current_user.categories
  end

end

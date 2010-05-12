class Judging::CategoryCommentsController < Judging::JudgingSiteController

  hobo_model_controller

  def create
    hobo_create do
      redirect_to @this.category
    end
  end

end

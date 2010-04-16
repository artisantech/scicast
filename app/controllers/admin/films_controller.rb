class Admin::FilmsController < Admin::AdminSiteController

  hobo_model_controller

  auto_actions :index, :show, :edit, :update
  
  def index
    films = case params[:show]
            when "Submission Completed"
              Film.submission_completed
            when "Submission Not Completed"
              Film.submission_not_completed
            else
              Film
            end
    hobo_index films.apply_scopes(:search => [params[:search], :title])
  end

end

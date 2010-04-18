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
    hobo_index films.apply_scopes(:search => [params[:search], :title]).limit(5) do |respond|
      puts request.xhr?
      respond.html
      respond.js { render :text => @films.to_json(:only => ['title', 'id'], :methods => [:tag_list]) }
    end
  end
  
  index_action :organise
  
  web_method :tag do
    this.tag_list.add params[:name]
    this.save
    render :nothing => true
  end

  web_method :untag do
    this.tag_list.remove params[:name]
    this.save
    render :nothing => true
  end

end

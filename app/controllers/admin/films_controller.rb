class Admin::FilmsController < Admin::AdminSiteController

  hobo_model_controller

  auto_actions :index, :show, :edit, :update, :destroy
  
  def index
    if params[:tags]
      @films = Film.find_tagged_with(params[:tags], :match_all => true)
      render :text => @films.to_json(:only => ['title', 'id'], :methods => [:tag_list])
    else
      films = case params[:show]
              when "Submission Completed"
                Film.submission_completed
              when "Submission Not Completed"
                Film.submission_not_completed
              else
                Film
              end
      hobo_index films.apply_scopes(:search => [params[:search], :title]), :per_page => 10 do |respond|
        respond.html
        respond.js { render :text => @films.to_json(:only => [:title, :id], :methods => [:tag_list, :reference_code ]) }
      end
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
  
  web_method :upload_for_web do
    @this.processed_movie = params[:Filedata]
    @this.save(false)
    render :nothing => true
  end

end

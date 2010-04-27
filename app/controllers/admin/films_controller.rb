class Admin::FilmsController < Admin::AdminSiteController

  hobo_model_controller

  auto_actions :index, :show, :edit, :update, :destroy
  
  auto_actions_for :user, [:new, :create]
  
  FILTER_SCOPES = { 'Submission Completed'     => :submission_completed, 
                    'Submission Not Completed' => :submission_not_completed,
                    'Published'                => :published,
                    'Not Published'            => :not_published }
  
  def index
    if params[:tags]
      @films = Film.find_tagged_with(params[:tags], :match_all => true)
      render_films_json
    else
      films = if (filter = FILTER_SCOPES[params[:show]])
                Film.send(filter)
              else
                Film
              end
      hobo_index films.apply_scopes(:search => [params[:search], :title, :team_name, :reference_code],
                                    :order_by => parse_sort_param(:title, :music, :video, :stills, :safety, :paperwork, :published)),
                 :per_page => 10 do |respond|
        respond.html
        respond.js do
          render_films_json
        end
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
  
  private
  
  def render_films_json
    render :text => @films.to_json(:only => [:title, :id], :methods => [:tag_list, :reference_code, :web_movie_url, :thumbnail_url ])
  end

end

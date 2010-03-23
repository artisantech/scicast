class FilmsController < ApplicationController

  hobo_model_controller
  
  auto_actions :edit, :update
  
  auto_actions_for :user, :create
  
  def show
    @film = Film.find params[:id]
    if !@film.movie.file?
      redirect_to @film, :edit
    end
  end
  
  web_method :upload do
    @this.movie = params[:Filedata]
    @this.save!(false)
    render :nothing => true
  end
  
  def create_for_user
    hobo_create do
      if valid?
        flash[:notice] = nil
      else
        @this = current_user
        render :template => "users/show"
      end
    end
  end
  
  def update
    hobo_update do
      redirect_to @film.user if valid?
    end
  end

end

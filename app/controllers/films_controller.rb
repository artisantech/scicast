class FilmsController < ApplicationController

  hobo_model_controller
  
  auto_actions :show
  
  auto_actions_for :user, :create
  
  show_action :upload_file
  
  web_method :upload do
    @this.movie = params[:Filedata]
    @this.save!
    render :nothing => true
  end
  
  def create_for_user
    hobo_create do
      if valid?
        flash[:notice] = nil
        redirect_to @this, :upload_file
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

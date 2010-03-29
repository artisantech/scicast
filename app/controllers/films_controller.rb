class FilmsController < ApplicationController

  hobo_model_controller
  
  auto_actions :edit, :update
  
  auto_actions_for :user, :create
  
  def show
    @film = Film.find params[:id]
    if @film.needs_file?
      redirect_to @film, :edit
    elsif !@film.agreements_posted?
      redirect_to @film, :print_and_post
    end
  end
  
  show_action :print_and_post
  show_action :license
  show_action :performer_consent
  
  web_method :upload do
    @this.movie = params[:Filedata]
    @this.save(false)
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
      if valid?
        if this.ready?
          flash[:notice] = "Your film has been successfully submitted!"
          this.submission_complete!
          redirect_to @film.user
        end
        flash[:notice] = nil
      end
    end
  end

end

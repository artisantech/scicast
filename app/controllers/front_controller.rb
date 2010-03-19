class FrontController < ApplicationController

  hobo_controller

  def index
    redirect_to user_signup_url
  end

  def search
    if params[:query]
      site_search(params[:query])
    end
  end

end

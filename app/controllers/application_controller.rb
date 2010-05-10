# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def home_page
    if current_user.administrator?
      admin_films_path
    elsif current_user.judge?
      judging_categories_path
    else
      obejct_url current_user
    end
  end
  
end

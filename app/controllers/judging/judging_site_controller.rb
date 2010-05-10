class Judging::JudgingSiteController < ApplicationController

  hobo_controller

  before_filter :judge_or_admin_required
  
  private
  
  def judge_or_admin_required
    redirect_to home_page unless current_user.administrator? || current_user.judge?
  end  
  
end

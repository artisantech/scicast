class Judging::UsersController < Judging::JudgingSiteController

  hobo_user_controller
  
  skip_before_filter :judge_or_admin_required, :only => [:login, :forgot_password, :reset_password, :do_reset_password ]

  auto_actions :login, :logout, :reset_password, :do_reset_password, :account
  
  def forgot_password
    if request.post?
      user = model.find_by_email(params[:email_address]) and user.lifecycle.request_password_reset!(:nobody)
      render_tag :forgot_password_email_sent_page
    end
  end
  
end
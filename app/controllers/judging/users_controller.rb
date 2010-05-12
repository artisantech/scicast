class Judging::UsersController < Judging::JudgingSiteController

  hobo_user_controller
  
  skip_before_filter :judge_or_admin_required, :only => [:login, :forgot_password, :reset_password, :do_reset_password ]

  auto_actions :login, :logout, :forgot_password, :do_reset_password, :account
  
end
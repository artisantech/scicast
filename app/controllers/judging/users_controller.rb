class Judging::UsersController < Judging::JudgingSiteController

  hobo_user_controller

  auto_actions :account, :update

end

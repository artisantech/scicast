class UserMailer < ActionMailer::Base
  
  def forgot_password(user, key)
    prepare_message user.email, "Request new password", :user => user, :key => key
  end
  
  def activation(user, key)
    prepare_message user.email, "Activate your account", :user => user, :key => key
  end
  
  private 
  
    def prepare_message(recipient, subject, body_attribtes)
      app_name = Hobo::Controller.app_name || host

      @recipients = recipient
      @subject    = "#{app_name} -- #{subject}"
      @from       = APP_REPLY_ADDRESS

      @sent_on    = Time.now
      @headers    = {}
      @body       = body_attribtes.merge :host => APP_DOMAIN, :app_name => app_name
    end  
end

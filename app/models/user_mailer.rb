class UserMailer < ActionMailer::Base
  
  def forgot_password(user, key)
    prepare_message user.email, "forgot_password password", :user => user, :key => key
  end
  
  def activation(user, key)
    prepare_message user.email, "activate your account", :user => user, :key => key
  end
  
  private 
  
    def prepare_message(recipient, subject, body_attribtes)
      host = Hobo::Controller.request_host
      app_name = Hobo::Controller.app_name || host

      @recipients = recipient
      @subject    = "#{app_name} -- #{subject}"
      @from       = "no-reply@#{host}"
      @sent_on    = Time.now
      @headers    = {}
      @body       = body_attribtes.merge :host => host, :app_name => app_name
    end  
end

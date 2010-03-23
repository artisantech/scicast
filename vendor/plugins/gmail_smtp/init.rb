if Rails.env.staging? 
  require 'smtp_tls'
  require 'actionmailer_gmail'
end

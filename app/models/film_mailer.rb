class FilmMailer < ActionMailer::Base
  

  def submitted(film)
    @recipients = ADMIN_EMAIL_ADDRESS
    @subject    = "SciCast Submissions -- Film #{film.reference_code} submitted"
    @from       = APP_REPLY_ADDRESS
    @sent_on    = Time.now
    @headers    = {}
    @body       = { :film => film }
  end
  
  def comment_posted(comment)
    @recipients = comment.email_recipients.*.email
    @subject    = "SciCast Submissions -- New comment on #{comment.film.title}"
    @from       = APP_REPLY_ADDRESS
    @sent_on    = Time.now
    @headers    = {}
    @body       = { :comment => comment }
  end

end

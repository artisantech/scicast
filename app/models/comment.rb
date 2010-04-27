class Comment < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    body :text
    timestamps
  end
  
  belongs_to :film
  belongs_to :author, :class_name => "User", :creator => true
  
  def email_recipients
    ([film.user] | film.commenters) - [author]
  end
  
  after_create :send_emails
  def send_emails
    FilmMailer.deliver_comment_posted(self)
  end

  # --- Permissions --- #

  def create_permitted?
    return false unless author == acting_user
    acting_user.administrator? or
     acting_user == film.user && film.comments.any?
  end

  def update_permitted?
    false
  end

  def destroy_permitted?
    false
  end

  def view_permitted?(field)
    acting_user.administrator? || acting_user == film.user
  end

end

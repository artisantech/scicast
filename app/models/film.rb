class Film < ActiveRecord::Base
  
  Status  = HoboFields::EnumString.for :not_started, :in_progress, :pass, :fail
  License = HoboFields::EnumString.for :cc_by, :cc_by_nc_sa

  hobo_model # Don't put anything above this

  fields do
    title :string
    description :text
    
    team_name :string
    team_info :text

    editorial_notes :text
    unique_id :string
    
    duration :integer # In seconds
    
    license License
    
    music_status   Status
    video_status   Status
    stills_status  Status
    safety_status  Status
    science_status Status
    
    production_date :date
    
    aspect enum_string('4:3', '16:9')
    
    published :boolean
    
    submit_by_post :boolean
    
    agreements_posted :boolean
    
    timestamps
  end
  
  ADMIN_FIELDS = %w(editorial_notes duration 
                    music_status video_status stills_status safety_status science_status
                    aspect published
                    processed_movie tumbnail)
                    
  USER_FIELDS = %w(title description production_date license
                   team_name team_info
                   license)
                   
  validates_presence_of *(USER_FIELDS + [{:on => :update}])
  
  
  
  def self.paperclip_options
    if Rails.env.staging?
      # We're staging on heroku, so use S3
      { :storage => :s3, :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", :path => ":attachment/:id/:style.:extension" }
    else
      {}
    end
  end
  
  with_options(paperclip_options) do |o|
    o.has_attached_file :movie
    o.has_attached_file :processed_movie
    o.has_attached_file :thumbnail
  end
  
  belongs_to :user, :creator => true
  
  never_show *attachment_fields(:movie, :processed_movie, :thumbnail)
  
  def activating?
    lifecycle.active_step.name == :activate
  end
  
  def reference_code
    return nil if id.nil?
    
    # SHA1 hash, translated into base 32 (!) to be more compact, truncated to first 6 characters
    # or 7 if id >= 28838, where there is a collision
    # (32 = 10 digits + 26 letters - 4 dodgy ones)
    len = id >= 28838 ? 7 : 6
    Digest::SHA1.hexdigest(id.to_s).to_i(16).to_s(32)[0...len].upcase.tr('O01I', 'WXYZ')
  end
  
  def ready?
    movie.file? && agreements_posted?
  end
  
  def submission_complete!
    FilmMailer.deliver_submitted(self)
  end
  
  # --- Permissions --- #

  def create_permitted?
    acting_user.guest? || acting_user == user
  end

  def update_permitted?
    acting_user.administrator? or
      only_changed? *(USER_FIELDS + %w(submit_by_post movie_file_name movie_file_size movie_content_type movie_updated_at))
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end
  
  def upload_permitted?
    acting_user == user or user.films.length == 1
  end


end

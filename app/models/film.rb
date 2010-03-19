class Film < ActiveRecord::Base
  
  Status = HoboFields::EnumString.for :started, :in_progress, :pass, :fail

  hobo_model # Don't put anything above this

  fields do
    title :string, :required
    description :text, :required
    team_name :string, :required

    editorial_notes :text
    unique_id :string
    
    duration :integer # In seconds
    
    music_status Status
    video_status Status
    stills_status Status
    safety_status Status
    science_status Status
    
    aspect enum_string('4:3', '16:9')
    
    published :boolean
    
    timestamps
  end
  
  ADMIN_FIELDS = %w(editorial_notes duration 
                    music_status video_status stills_status safety_status science_status
                    aspect published
                    processed_movie tumbnail)
                    
  SUBMISSION_FIELDS = %w(title movie description team_name user movie_file_name movie_file_size movie_content_type movie_updated_at)
  
  has_attached_file :movie
  has_attached_file :processed_movie
  has_attached_file :thumbnail
  
  validates_attachment_presence :movie, :message => "must be provided"
  
  belongs_to :user, :creator => true
  
  # --- Permissions --- #

  def create_permitted?
    only_changed?(*SUBMISSION_FIELDS) and
    acting_user.guest? || acting_user == user
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end

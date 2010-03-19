class Film < ActiveRecord::Base
  
  Status = HoboFields::EnumString.for :started, :in_progress, :pass, :fail

  hobo_model # Don't put anything above this

  fields do
    title :string, :required
    description :text, :required
    
    team_name :string, :required
    team_info :text, :required

    editorial_notes :text
    unique_id :string
    
    duration :integer # In seconds
    
    license enum_string(:cc_by, :cc_by_nc_sa), :required
    
    music_status   Status
    video_status   Status
    stills_status  Status
    safety_status  Status
    science_status Status
    
    production_date :date, :required
    
    aspect enum_string('4:3', '16:9')
    
    published :boolean
    
    timestamps
  end
  
  ADMIN_FIELDS = %w(editorial_notes duration 
                    music_status video_status stills_status safety_status science_status
                    aspect published
                    processed_movie tumbnail)
                    
  SUBMISSION_FIELDS = %w(user
                         title movie description production_date license
                         team_name team_info
                         movie_file_name movie_file_size movie_content_type movie_updated_at)
  
  
  with_options :storage => :s3,
               :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
               :path => ":attachment/:id/:style.:extension" do |o|
    o.has_attached_file :movie
    o.has_attached_file :processed_movie
    o.has_attached_file :thumbnail
  end
  
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

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
    
    reference_code :string
    
    license License
    
    music_status   Status
    video_status   Status
    stills_status  Status
    safety_status  Status
    science_status Status
    
    production_date :date
    
    aspect enum_string('4:3', '16:9')
    
    others_material :text
    
    published :boolean
    
    submit_by_post :boolean
    
    agreements_posted :boolean
    
    timestamps
  end
  
  acts_as_taggable
  
  ADMIN_FIELDS = %w(editorial_notes duration 
                    music_status video_status stills_status safety_status science_status
                    aspect published
                    processed_movie tumbnail)
                    
  REQUIRED_USER_FIELDS = %w(title description production_date license
                            team_name team_info
                            license)
                   
  validates_presence_of *(REQUIRED_USER_FIELDS + [{:on => :update}])
  
  named_scope :submission_completed, :conditions => "movie_file_name is not null and agreements_posted"
  named_scope :submission_not_completed, :conditions => "movie_file_name is null or not agreements_posted or agreements_posted is null"
  
  
  
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
    o.has_attached_file :thumbnail, :styles => { :small => "38x35#", :large => "100x100#" }
  end
  
  belongs_to :user, :creator => true
  has_many :comments
  has_many :commenters, :through => :comments, :source => :author, :uniq => true
  
  never_show *attachment_fields(:movie, :processed_movie, :thumbnail)
  
  def title
    read_attribute(:title) || (new_record?? "" : "(No Title)")
  end
  
  def activating?
    lifecycle.active_step.name == :activate
  end
  
  after_create :create_reference_code
  def create_reference_code
    # SHA1 hash, translated into base 32 (!) to be more compact, truncated to first 6 characters
    # or 7 if id >= 28838, where there is a collision
    # (32 = 10 digits + 26 letters - 4 dodgy ones)
    len = id >= 28838 ? 7 : 6
    self.reference_code = Digest::SHA1.hexdigest(id.to_s).to_i(16).to_s(32)[0...len].upcase.tr('O01I', 'WXYZ')
    update_without_hobo_permission_check
  end
  
  def needs_file?
    !(movie.file? || submit_by_post?)
  end
  
  def ready?
    (!needs_file?) && agreements_posted?
  end
  
  def submission_complete!
    FilmMailer.deliver_submitted(self)
  end
  
  def web_movie_url
    processed_movie.url if processed_movie.file?
  end

  def thumbnail_url
    thumbnail.url(:small) if thumbnail.file?
  end
  
  # --- Permissions --- #

  def create_permitted?
    acting_user.guest? || acting_user == user || acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator? or
      only_changed? *(REQUIRED_USER_FIELDS + %w(submit_by_post movie_file_name movie_file_size movie_content_type movie_updated_at others_material agreements_posted))
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    new_record? || user == acting_user || acting_user.administrator? || user.state == 'inactive'
  end
  
  def upload_permitted?
    acting_user == user || user.state == 'inactive'
  end

  def upload_for_web_permitted?
    acting_user.administrator?
  end
  
  def tag_permitted?;   acting_user.administrator? end
  def untag_permitted?; acting_user.administrator? end


end

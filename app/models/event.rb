class Event < ActiveRecord::Base

   belongs_to :municipality

  attr_accessible :subject, :intro, :description, :start_time, :stop_time, :street, :zip, :city, :loc_descr, :lat, :lng, :municipality_id

  validates_presence_of :subject, :description, :stop_time, :municipality_id, :start_date, :start_clock
  validates_length_of :subject, :in => 10..40
  validates_length_of :intro, :in => 0..90
  validates_numericality_of :lat, :allow_nil => true
  validates_numericality_of :lng, :allow_nil => true
  #validates_datetime :start_time, :allow_nil => false
  validates_datetime :stop_time, :allow_nil => false
  validates_datetime :stop_time, :after => :start_time
  validates_datetime :start_date, :allow_nil => false

  
 # validate :datetime_format_and_existence_is_valid  
  before_save :merge_and_set_start_time    
# http://stackoverflow.com/questions/1467904/how-do-ruby-on-rails-multi-parameter-attributes-really-work-datetime-select
  
  def start_date
    if (self.start_time) then self.start_time.strftime "%Y-%m-%d"
    else @start_date ||= (Time.now).strftime "%Y-%m-%d" 
    end
  end

  def start_date=(date_string)
    self.start_date = date_string.strip
  end

  def start_clock
    if self.start_time then self.start_time.strftime "%H:%M"
    else @start_clock ||= Time.now.strftime "%H:%M" #default
    end
  end

  def start_clock=(time_string)
    self.start_clock = time_string.strip
  end

  # if parsing of the merged date and time strings is
  # unsuccessful, add an error to the queue and fail
  # validation with a message
  def datetime_format_and_existence_is_valid    
    #errors.add(:start_date, 'must be in YYYY-MM-DD format') unless
    #  (@start_date =~ /\d{4}-\d\d-\d\d/) # check the date's format
    #errors.add(:start_clock, 'must be in HH:MM format') unless # check the time's format
    #  (@start_clock =~ /^((0?[1-9]|1[012])(:[0-5]\d){0,2}(\ [AaPp][Mm]))$|^(([01]\d|2[0-3])(:[0-5]\d){0,2})$/)
    # build the complete date + time string and parse
    #@start_time_str = @start_date + " " + @start_clock
    #errors.add(:start_date, "doesn't exist") if 
    #  ((DateTime.parse(@start_time_str) rescue ArgumentError) == ArgumentError)
  end

  # callback method takes constituent strings for date and 
  # time, joins them and parses them into a datetime, then
  # writes this datetime to the object
  private
  def merge_and_set_start_time
    @start_time_str = self.start_date + " " + self.start_clock
    self.start_time = DateTime.parse(@start_time_str)
  end

end
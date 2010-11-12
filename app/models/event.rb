class Event < ActiveRecord::Base

   belongs_to :municipality

  attr_accessible :subject, :intro, :description, :stop_datetime, :street, :zip, :city, :loc_descr, :lat, :lng, :municipality_id, :start_date, :start_time

  validates_presence_of :subject, :description, :municipality_id, :start_date, :start_time
  validates_length_of :subject, :in => 10..40
  validates_length_of :intro, :in => 0..90
  validates_numericality_of :lat, :allow_nil => true
  validates_numericality_of :lng, :allow_nil => true
  #validates_time :start_time, :allow_nil => false
  #validates_date :start_date, :allow_nil => false
  
  #validates_datetime :start_datetime, :allow_nil => false
  #validates_datetime :stop_datetime, :allow_nil => false
  #validates_datetime :stop_datetime, :after => :start_datetime
  #validates_datetime :start_datetime, :allow_nil => false

  validate :validates_start_time
  
  before_save :merge_start_datetime    

  #http://stackoverflow.com/questions/1467904/how-do-ruby-on-rails-multi-parameter-attributes-really-work-datetime-select
 

 

  def start_time
    if(self.start_datetime) then self.start_datetime.strftime "%H:%M"
    else @start_time ||= "19:00" #default
    end
  end

 
 def start_time=(time_str)
  @start_time = time_str.strip
 end

 
 #def start_date
 # if @start_date then
 #   @start_date
 # else
 #   if @start_datetime then
 #     @start_datetime.datetime.strftime "%Y-%m-%d"
 #   else
 #     Time.now.strftime "%Y-%m-%d"
 #   end
 # end
 #end

  def start_date
    if(self.start_datetime) then self.start_datetime.strftime "%Y-%m-%d"
    else @start_date  ||= (Time.now + 2.days).strftime "%Y-%m-%d" #default
    end
  end
 
 
  def start_date=(date_str)
    @start_date = date_str.strip
  end

  def validates_start_time
    begin
      DateTime.parse(@start_time) 
    rescue
      errors.add(:start_time, 'zz must be in HH:MM format')
    end
  end
  
  def merge_start_datetime
    self.start_datetime = DateTime.parse(@start_date + " " + @start_time) if errors.empty?
  end



end


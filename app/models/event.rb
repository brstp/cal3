class Event < ActiveRecord::Base

  #TODO: Move default start/stop dates/times to inializers
  #TODO: Check if use of 'self' is ok
  #TODO: Use validates_time, validates_date

  belongs_to :municipality
  belongs_to :organizer

  before_save :merge_start_datetime, :merge_stop_datetime

  attr_accessible :subject, :intro, :description, :street, :zip, :city, :loc_descr, :lat, :lng, :municipality_id, :start_date, :start_time, :stop_date, :stop_time, :organizer_id,   :phone_number, :phone_name, :email, :email_name


  validates_presence_of :subject, :description, :municipality_id, :start_date, :start_time, :stop_date, :stop_time, :organizer_id, :email, :email_name
  validates_length_of :subject, :in => 7..40
  validates_length_of :intro, :in => 0..90
  validates_numericality_of :lat, :allow_nil => true
  validates_numericality_of :lng, :allow_nil => true
  validate :validates_start_time, :validates_start_date, :validates_stop_time, :validates_stop_date, :validates_start_stop, :validates_phone_details
  validates :phone_number, :phone => true
  validates :email, :email => true
  # validates_presence_of :phone_name, :unless => :blank_phone_number


#  searchable do
#    string :subject
#    text :description
#  end



  def upcoming_events
    self.find(:all, :conditions => ["stop_datetime >= '#{Time.now}'"], :order => "start_datetime ASC")  
  end
  
  def municipality_short
    municipality.short_name
  end

  def duration
    # TODO if not same day, better wording of end time, depending of length
    duration = I18n.localize(start_datetime, :format => :longest) + " - " 
    if @start_date != @stop_date
      duration += I18n.localize(stop_datetime, :format => :longest)
    end
    duration += I18n.localize(stop_datetime, :format => :time)
  end
 

  def start_date=(date_str)
    @start_date = date_str.strip
  end
  
  def start_time=(time_str)
    @start_time = time_str.strip
  end
  
  def stop_date=(date_str)
    @stop_date = date_str.strip
  end

  def stop_time=(time_str)
    @stop_time = time_str.strip
  end 
  

  def start_date
    if(self.start_datetime) then 
      I18n.localize(self.start_datetime, :format => :date) 
    else 
      @start_date  ||= I18n.localize((Time.now + 2.days), :format => :date) #default
    end
  end  

   def stop_date
    if(self.stop_datetime) then 
      I18n.localize(self.stop_datetime, :format => :date) 
    else 
      @stop_date  ||= I18n.localize((Time.now + 2.days), :format => :date)
    end
  end
  
  def start_time
    if(self.start_datetime) then 
      I18n.localize(self.start_datetime, :format => :time) 
    else 
      @start_time ||= "19.00" #default
    end
  end

  
  def stop_time
    if(self.stop_datetime) then 
      I18n.localize(self.stop_datetime, :format => :time)
    else 
      @stop_time ||= "19.00" #default
    end
  end
 

protected
 
  def merge_start_datetime 
    self.start_datetime = Timeliness.parse(@start_date + " " + @start_time) if errors.empty?
  end
  
  def merge_stop_datetime 
    self.stop_datetime = Timeliness.parse(@stop_date + " " + @stop_time) if errors.empty?
  end

  def validates_start_time
    errors.add(:start_time, I18n.t('errors.messages.invalid_time')) unless Timeliness.parse(@start_time) 
  end

  def validates_start_date
    errors.add(:start_date, I18n.t('errors.messages.invalid_date')) unless Timeliness.parse(@start_date) 
  end
    
 
  def validates_stop_time
    errors.add(:stop_time, I18n.t('errors.messages.invalid_time')) unless Timeliness.parse(@stop_time) 
  end

  def validates_stop_date
      errors.add(:stop_date, I18n.t('errors.messages.invalid_date')) unless Timeliness.parse(@stop_date) 
  end
  

  def validates_start_stop
    if errors.empty?
      if @start_date > @stop_date
        errors.add(:stop_date, I18n.t('error.messages.on_or_after', :restriction => @start_date))
      else
        if @start_date == @stop_date and @start_time > @stop_time
          errors.add(:stop_time, I18n.t('error.messages.on_or_after', :restriction => @start_time))
          end
      end
    end
  end

  def validates_phone_details
    if self.phone_number.blank? and not self.phone_name.blank?
      errors.add(:phone_number, I18n.t('errors.messages.name_but_no_phone'))
    else
      if not self.phone_number.blank? and self.phone_name.blank?
        errors.add(:phone_name, I18n.t('errors.messages.phone_but_no_name'))
      end
    end
  end

end

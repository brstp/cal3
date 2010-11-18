class Event < ActiveRecord::Base

  belongs_to :municipality
  belongs_to :organizer

  before_save :merge_start_datetime, :merge_stop_datetime

  attr_accessible :subject, :intro, :description, :street, :zip, :city, :loc_descr, :lat, :lng, :municipality_id, :start_date, :start_time, :stop_date, :stop_time, :organizer_id

  validates_presence_of :subject, :description, :municipality_id, :start_date, :start_time, :stop_date, :stop_time, :organizer_id
  validates_length_of :subject, :in => 10..40
  validates_length_of :intro, :in => 0..90
  validates_numericality_of :lat, :allow_nil => true
  validates_numericality_of :lng, :allow_nil => true
  validate :validates_start_time, :validates_start_date, :validates_stop_time, :validates_stop_date, :validates_start_stop
  

  
  def duration
    duration = start_datetime.strftime('%A %d %B %Y kl. %H:%M') + " - " 
    if @start_date != @stop_date
      duration += stop_datetime.strftime('%A %d %B kl. ')
    end
    duration += stop_datetime.strftime('%H.%M')
  end
 
  def municipality_short
    municipality.short_name
  end

  def start_time
    if(self.start_datetime) then self.start_datetime.strftime "%H:%M"
    else @start_time ||= "19:00" #default
    end
  end

  def start_time=(time_str)
    @start_time = time_str.strip
  end

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
      errors.add(:start_time, I18n.t('errors.messages.invalid_time'))
    end
  end

  def validates_start_date
    begin
      DateTime.parse(@start_date) 
    rescue
      errors.add(:start_date, I18n.t('errors.messages.invalid_date'))
    end
  end
    
  def merge_start_datetime
    self.start_datetime = DateTime.parse(@start_date + " " + @start_time) if errors.empty?
  end
  
  

  def stop_time
    if(self.stop_datetime) then self.stop_datetime.strftime "%H:%M"
    else @stop_time ||= "19:00" #default
    end
  end
  
  def stop_time=(time_str2)
    @stop_time = time_str2.strip
  end

  def stop_date
    if(self.stop_datetime) then self.stop_datetime.strftime "%Y-%m-%d"
    else @stop_date  ||= (Time.now + 2.days).strftime "%Y-%m-%d" #default
    end
  end
 
  def stop_date=(date_str2)
    @stop_date = date_str2.strip
  end

  def validates_stop_time
    begin
      DateTime.parse(@stop_time) 
    rescue
      errors.add(:stop_time, I18n.t('errors.messages.invalid_time'))
    end
  end

  def validates_stop_date
    begin
      DateTime.parse(@stop_date) 
    rescue
      errors.add(:stop_date, I18n.t('errors.messages.invalid_date'))
    end
  end
  
  def merge_stop_datetime
    self.stop_datetime = DateTime.parse(@stop_date + " " + @stop_time) if errors.empty?
  end

  def validates_start_stop
    if @start_date > @stop_date
      errors.add(:stop_date, I18n.t('error.messages.on_or_after', :restriction => @start_date))
    else
      if @start_date == @stop_date and @start_time > @stop_time
        errors.add(:stop_time, I18n.t('error.messages.on_or_after', :restriction => @start_time))
        end
    end
  end

end

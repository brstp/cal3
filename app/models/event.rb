class Event < ActiveRecord::Base
  
  #TODO: Move default start/stop dates/times to inializers
  #TODO: Check if use of 'self' is ok
  #TODO: Use validates_time, validates_date

  belongs_to :municipality
  belongs_to :organizer
  belongs_to :category

  before_save :merge_start_datetime, :merge_stop_datetime
  after_validation :consider_fetch


  attr_accessible :subject, :intro, :description, :street, :zip, :city, :loc_descr, :lat, :lng, :municipality_id, :start_date, :start_time, :stop_date, :stop_time, :organizer_id, :phone_number, :phone_name, :email, :email_name, :category_id, :counter, :start_datetime, :stop_datetime


  validates_presence_of :subject, :description, :municipality_id, :start_date, :start_time, :stop_date, :stop_time, :organizer_id, :email, :email_name, :category_id
  validates_length_of :subject, :in => 7..40
  validates_length_of :intro, :in => 0..90
  validates_numericality_of :lat, :allow_nil => true
  validates_numericality_of :lng, :allow_nil => true
  validate :validates_start_time, :validates_start_date, :validates_stop_time, :validates_stop_date, :validates_start_stop, :validates_phone_details
  validates :phone_number, :phone => true
  validates :email, :email => true
  # validates_presence_of :phone_name, :unless => :blank_phone_number

  geocoded_by :street, :latitude => :lat, :longitude => :lng

  searchable :auto_index => true, :auto_remove => true do
    text :subject, :boost => 3.0
    text :intro, :boost => 2.0
    text :description
    text :street
    text :city
    text :loc_descr
    text :phone_name
    text :email_name
    text :category
    text :organizer
    text :municipality
    time :start_datetime
    # start_date trie
    # lat/lng trie
    # 
    # text :category_names do
      # categories.map { |category| category.name}
    # end
    integer :category_id, :references => ::Category
    integer :municipality_id, :references => ::Municipality
    integer :organizer_id, :references => ::Organizer
    
    string :date_facet, :multiple => true do
      if self.start_datetime < Time.now+30.day 
        "next_30_days"
      end
      if self.start_datetime < Time.now+10.day 
        "next_10_days"
      end
    end
    
  end

  def location
    str = ""
    unless self.loc_descr.blank? 
      str += self.loc_descr + "\n"
    end
    unless self.street.blank? 
      str += self.street + "\n"
    end
    unless self.zip.blank? 
      str += self.zip + " "
    end
    unless self.city.blank? 
      str += self.city
    end
    str.strip
  end
  
  def ical
    e = Icalendar::Event.new
    c = Icalendar::Calendar.new
    #TODO Better way to point out url with helper (uid/url)
    e.uid = "http://www.foreningskalendern.se/event/#{self.id}"    
    e.dtstart = I18n.localize(self.start_datetime, :format => :icalendar)
    e.dtend = I18n.localize(self.stop_datetime, :format => :icalendar)    
    e.summary = self.subject
    e.description = self.description
    e.created = I18n.localize(self.created_at, :format => :icalendar)   
    e.url = e.uid    
    #TODO: url to organizer page...
    e.organizer = self.organizer.name
    e.location = self.location
    e.geo = "#{self.lat.to_s};#{self.lng.to_s}"
    e.last_modified = I18n.localize(self.updated_at, :format => :icalendar)
    c.add e
    c.publish
    c.to_ical
  end
  
  def ical_single_event
    e = Icalendar::Event.new
    #TODO Better way to point out url with helper (uid/url)
    e.uid = "http://www.foreningskalendern.se/event/#{self.id}"    
    e.dtstart = I18n.localize(self.start_datetime, :format => :icalendar)
    e.dtend = I18n.localize(self.stop_datetime, :format => :icalendar)    
    e.summary = self.subject
    e.description = self.description
    e.created = I18n.localize(self.created_at, :format => :icalendar)   
    e.url = e.uid    
    #TODO: url to organizer page...
    e.organizer = self.organizer.name
    e.location = self.location
    e.geo = "#{self.lat.to_s};#{self.lng.to_s}"
    e.last_modified = I18n.localize(self.updated_at, :format => :icalendar)
    e
  end

    
  def consider_fetch
    if lat == nil or lng == nil
    fetch_coordinates
    end
  end

  #TODO A generic degree to Sdd°mm,mmm converter.
  def degrees_to_degrees_minutes degrees_float
    degrees = degrees_float.to_i
    minutes = ((degrees_float - degrees).abs * 60 * 1000).to_i/1000.0
    degrees.to_s + '&deg;' + minutes.to_s + '\''
  end
  
  def lat_lng
    pos_str = ''
    if lat >= 0 
      pos_str += 'N '
    else
      pos_str += 'S '
    end
    pos_str += degrees_to_degrees_minutes(lat) 
    pos_str += ' '
    if lng >= 0 
      pos_str += 'O '
    else
      pos_str += 'V '
    end
    pos_str += degrees_to_degrees_minutes(lng)
    pos_str
  end
  
  def location
    output_str = street + ', ' + city + ', ' + municipality.name + ', Sverige'
    output_str
  end

  def upcoming_events 
    # self.find(:all, :conditions => ["stop_datetime >= '#{Time.now}'"], :order => "start_datetime ASC")
    Event.where("stop_datetime >= ? AND start_datetime <= ?", 
                Time.now.beginning_of_day, Time.now.end_of_day + 2.months ).
                order('start_datetime ASC').limit 200 
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

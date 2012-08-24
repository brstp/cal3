# encoding: UTF-8
class Event < ActiveRecord::Base
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::UrlHelper

  #TODO: Move default start/stop dates/times to inializers
  #TODO: Check if use of 'self' is ok
  #TODO: Use validates_time, validates_date

  belongs_to :municipality
  belongs_to :organizer
  belongs_to :category

  before_save :merge_start_datetime, :merge_stop_datetime
  before_save :destroy_image1?, :destroy_image2?, :destroy_image3?
  #after_validation :consider_fetch


  attr_accessible :subject, :intro, :description, :street, :loc_descr, :lat, :lng, :municipality_id, :last_googleboted,
                  :start_date, :start_time, :stop_date, :stop_time, :organizer_id, :phone_number, 
                  :phone_name, :email, :human_name, :category_id, :counter, :start_datetime, 
                  :stop_datetime, :image1, :image2, :image3, :created_by_user_id, :updated_by_user_id,
                  :image1_caption, :image1_url, :image1_delete, :image2_caption, :image2_url, :image2_delete, :image3_caption, :image3_url, :image3_delete


  validates_presence_of :subject, :description, :municipality_id, :start_date, :start_time, :organizer_id, :email, :human_name, :category 
  validates_length_of :subject, :in => 7..40
  validates_length_of :intro, :in => 0..90
  validates_numericality_of :lat, :allow_nil => true
  validates_numericality_of :lng, :allow_nil => true
  validates_length_of :image1_caption, :image2_caption, :image3_caption, :in => 0..60

                        
  validates :image1_url, :allow_blank => true, :uri => { :format => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix }
  validates :image2_url, :allow_blank => true, :uri => { :format => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix }
  validates :image3_url, :allow_blank => true, :uri => { :format => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix }
                        
  validate  :validates_start_time, :validates_start_date, :validates_stop_time, :validates_stop_date, :validates_start_stop
  validate :validates_phone_details
  validates :phone_number, :phone => true
  validates :email, :email => true

  extend FriendlyId
  friendly_id :subject, :use => :slugged

  geocoded_by :street, :latitude => :lat, :longitude => :lng

  searchable :auto_index => true, :auto_remove => true do
    text :subject, :boost => 3.0
    text :intro, :boost => 2.0
    text :description
    text :street
    text :loc_descr
    text :phone_name
    text :human_name
    text :category
    text :organizer
    text :municipality
    text :image1_caption
    text :image2_caption
    text :image3_caption
    time :start_datetime
    time :stop_datetime
    time :start, :trie => true, :using => :start_datetime
    time :stop, :trie => true, :using => :stop_datetime
    integer :category_id, :references => ::Category
    integer :category_facet_id, :multiple => true, :references => ::Category
    integer :municipality_id, :references => ::Municipality
    integer :organizer_id, :references => ::Organizer
  end

  acts_as_gmappable

  has_attached_file :image1,
      :storage => :s3,
      :bucket => 'static.allom.se',
      :path => "app/public/system/:attachment/:id/:style/:filename",
      :s3_credentials => {
        :access_key_id => ENV['S3_KEY'],
        :secret_access_key => ENV['S3_SECRET']
                         },
      :default_url => "missing-event.jpg",
      :styles => {:medium => "360x240#",
                  :small => "176x117#"}

  has_attached_file :image2,
      :storage => :s3,
      :bucket => 'static.allom.se',
      :s3_credentials => {
        :access_key_id => ENV['S3_KEY'],
        :secret_access_key => ENV['S3_SECRET']
                         },
      :default_url => "missing-event.jpg",
      :styles => {:medium => "360x240#",
                  :small => "176x117#"}

  has_attached_file :image3,
      :storage => :s3,
      :bucket => 'static.allom.se',
      :s3_credentials => {
        :access_key_id => ENV['S3_KEY'],
        :secret_access_key => ENV['S3_SECRET']
                          },
      :default_url => "missing-event.jpg",
      :styles => {:medium => "360x240#",
                  :small => "176x117#"}


  def image1_url= url_str
    unless url_str.blank?
      unless url_str.split(':')[0] == 'http' || url_str.split(':')[0] == 'https'
          url_str = "http://" + url_str
      end
    end  
    write_attribute :image1_url, url_str
  end

  def image1_delete
    @image1_delete ||= "0"
  end

  def image1_delete=(value)
    @image1_delete = value
  end


    def image2_url= url_str
    unless url_str.blank?
      unless url_str.split(':')[0] == 'http' || url_str.split(':')[0] == 'https'
          url_str = "http://" + url_str
      end
    end  
    write_attribute :image2_url, url_str
  end


  def image2_delete
    @image2_delete ||= "0"
  end

  def image2_delete=(value)
    @image2_delete = value
  end
  
    def image3_url= url_str
    unless url_str.blank?
      unless url_str.split(':')[0] == 'http' || url_str.split(':')[0] == 'https'
          url_str = "http://" + url_str
      end
    end  
    write_attribute :image3_url, url_str
  end


  def image3_delete
    @image3_delete ||= "0"
  end

  def image3_delete=(value)
    @image3_delete = value
  end
  
  
  def updated_by
    unless self.updated_by_user_id.nil?
      updated_by_user= User.find self.updated_by_user_id
      unless updated_by_user.blank?
        I18n.t('app.by') + ' ' + updated_by_user.name
      end
    end
  end
  
  def created_by
    unless self.created_by_user_id.nil?
      created_by_user= User.find self.created_by_user_id
      unless created_by_user.blank?
        I18n.t('app.by') + ' ' + created_by_user.name
      end  
    end
  end
  
  def category_facet_id
    category = self.category
    out_array = []
    while category.depth > 0
      out_array << category.id
      category = category.parent
    end
    out_array
  end

  def location
    str = ""
    unless self.loc_descr.blank?
      str += self.loc_descr + "\n"
    end
    unless self.street.blank?
      str += self.street + "\n"
    end
    str.strip
  end

  def ical
    e = Icalendar::Event.new
    c = Icalendar::Calendar.new
    #TODO Better way to point out url with helper (uid/url)
    e.uid = "http://allom.se/event/#{self.id}"
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
    e.uid = "http://allom.se/event/#{self.id}"
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
    if self.lat.blank? or self.lng.blank?
      fetch_coordinates unless self.street.blank?
    end
  end

  def init_lat
    self.lat.blank? ? 62.00 : self.lat
  end

  def init_lng
    self.lng.blank? ? 16.00 : self.lng
  end

  def init_zoom
    if (self.lat.blank? or self.lng.blank?)
      ""
    else
      "1"
    end
  end


  def re_geocoded_street
  end

  #TODO A generic degree to Sdd°mm,mmm converter.
  def degrees_to_degrees_minutes degrees_float
    degrees = degrees_float.to_i
    minutes = ((degrees_float - degrees).abs * 60 * 1000).to_i/1000.0
    degrees.to_s + '&deg;' + minutes.to_s + '\''
  end

  def lat_degrees_minute
    degrees = lat.to_i
    minutes = ((lat - degrees).abs * 60 * 1000).to_i/1000.0
    degrees.to_s + '°' + minutes.to_s + '\''
  end

  def lng_degrees_minute
    degrees = lng.to_i
    minutes = ((lng - degrees).abs * 60 * 1000).to_i/1000.0
    degrees.to_s + '°' + minutes.to_s + '\''
  end

  def lat_lng
    str = ""
    if lat >= 0
      str << %(N )
    else
      str << %(S )
    end
    str << %( #{lat_degrees_minute} )
    
    if lng >= 0
      str << %(O )
    else
      str << %(V )
    end
    str << %(#{lng_degrees_minute})
    str
  end
  
  def latitude
    self.lat
  end
  
  def longitude
    self.lng
  end
    

  
  def location
    output_str = street + ', ' + municipality.name + ', Sverige'
    output_str
  end

  def upcoming_events
    # self.find(:all, :conditions => ["stop_datetime >= '#{Time.now}'"], :order => "start_datetime ASC")
    Event.where("stop_datetime >= ? AND start_datetime <= ?",
                Time.now.beginning_of_day, Time.now.end_of_day + 12.months ).
                order('start_datetime ASC').limit 200
  end
  
  
  def municipality_short
    municipality.short_name
  end

  def duration
    # TODO if not same day, better wording of end time, depending of length
    duration = I18n.localize(start_datetime, :format => :longest)   
    unless  (self.start_datetime == self.stop_datetime)
      duration += " - "
      if self.start_date != self.stop_date
        duration += I18n.localize(stop_datetime, :format => :longest)
      else
        duration += I18n.localize(stop_datetime, :format => :time)
      end
    end
    duration
  end

  def short_duration
    # TODO if not same day, better wording of end time, depending of length
    duration = I18n.localize(start_datetime, :format => :short)   
    unless  (self.start_datetime == self.stop_datetime)
      duration += " - "
      if self.start_date != self.stop_date
        duration += I18n.localize(stop_datetime, :format => :short)
      else
        duration += I18n.localize(stop_datetime, :format => :time)
      end
    end
    duration
  end

  def start_date=(date_str)
    @start_date = date_str
  end

  def start_time=(time_str)
    @start_time = time_str
  end

  def stop_date=(date_str)
    unless date_str.blank?
      @stop_date = date_str
    else
      unless @start_date.blank?
        @stop_date = @start_date
      end
    end
  end

  def stop_time=(time_str)
    unless time_str.blank?
      @stop_time = time_str
    else
      unless @start_time.blank?
        @stop_time = @start_time
      end
    end
  end


  def start_date
    unless @start_date.blank?
      @start_date
    else
      if self.start_datetime then
        I18n.localize(self.start_datetime, :format => :date)
      else
        nil
      end
    end
  end

  def stop_date
    if(self.stop_datetime) then
      I18n.localize(self.stop_datetime, :format => :date)
    else
      @stop_date  
    end
  end

  def start_time
    unless @start_time.blank?
      @start_time
    else
      if self.start_datetime then
        I18n.localize(self.start_datetime, :format => :time)
      else
        nil
      end
    end  
  end


  def stop_time
    unless @stop_time.blank?
      @stop_time
    else
      if self.stop_datetime then
        I18n.localize(self.stop_datetime, :format => :time)
      else
        nil
      end
    end  
  end


protected

  def destroy_image1?
    if (@image1_delete == "1" )
      self.image1.clear 
      write_attribute :image1_caption, nil
      write_attribute :image1_url, nil
    end
  end
  
  def destroy_image2?
    if (@image2_delete == "1" )
      self.image2.clear 
      write_attribute :image2_caption, nil
      write_attribute :image2_url, nil
    end
  end

  def destroy_image3?
    if (@image3_delete == "1" )
      self.image3.clear 
      write_attribute :image3_caption, nil
      write_attribute :image3_url, nil
    end
  end  
  
  def merge_start_datetime
    if errors.empty?
      unless @start_date.blank? || @start_time.blank?
        self.start_datetime = Timeliness.parse(@start_date + " " + @start_time) 
      end
    end
  end

  def merge_stop_datetime
    if errors.empty?
      unless @stop_date.blank? || @stop_time.blank?
        self.stop_datetime = Timeliness.parse(@stop_date + " " + @stop_time) 
      end
    end
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
      if Timeliness.parse(@start_date) > Timeliness.parse(@stop_date)
        errors.add(:stop_date, I18n.t('error.messages.on_or_after', :restriction => @start_date))
      else
        if (Timeliness.parse(@start_date) == Timeliness.parse(@stop_date)) && (Timeliness.parse(@start_time) > Timeliness.parse(@stop_time))
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

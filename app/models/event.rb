# encoding: UTF-8
class Event < ActiveRecord::Base
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::UrlHelper
  include Assets::Normalizer

  #TODO: Move default start/stop dates/times to inializers
  #TODO: Check if use of 'self' is ok
  #TODO: Use validates_time, validates_date

  belongs_to :municipality
  belongs_to :organizer
  belongs_to :category
  has_many   :syndicated_by_organizers,
             :through => :organizer
             

  after_validation :merge_date_times
  before_save :destroy_image1?
  before_save :normalize_file_names
  #after_validation :consider_fetch
 
  attr_accessor :start_date, :start_time, :stop_date, :stop_time
  
  attr_accessible :subject, :intro, :description, :street, :loc_descr, 
                  :lat, :lng, :municipality_id,  
                  :phone_number, :phone_name, :email, :human_name, 
                  :category_id, 
                  :image1, :image1_caption, :image1_url, :image1_delete, 
                  :register, :price, :application_url, :organizer_id, 
                  :start_date, :start_time, :start_datetime,
                  :stop_date, :stop_time, :stop_datetime


  validates_presence_of :subject, :description, :municipality_id, :start_date, :start_time, :organizer_id, :email, :category 
  validates_length_of :subject, :in => 7..40, :allow_blank => true
  validates_length_of :intro, :in => 0..90
  validates_numericality_of :lat, :allow_nil => true
  validates_numericality_of :lng, :allow_nil => true
  validates_length_of :image1_caption, :in => 0..60
  validates :image1_url, :allow_blank => true, :uri => { :format => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix }
  validates :application_url, :allow_blank => true, :uri => { :format => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix }
  validates_attachment_content_type :image1, :content_type => /image/
  validates_attachment_size :image1, :in => 0..10.megabytes
  validate :validates_start_stop, :allow_blank => true
  validate :validates_phone_details
  validates :phone_number, :phone => true
  validates :email, :email => true

  extend FriendlyId
  friendly_id :subject, :use => [:slugged, :history]


  geocoded_by :street, :latitude => :lat, :longitude => :lng

  searchable :auto_index => true, :auto_remove => true do
    text :subject, :boost => 3.0
    text :intro, :boost => 2.0
    text :description
    text :street
    text :loc_descr
    text :phone_name
    text :human_name
    #text :category
    text :category1
    text :category2
    text :category3
    text :organizer
    text :municipality
    text :image1_caption
    time :start_datetime
    time :stop_datetime
    time :start, :trie => true, :using => :start_datetime
    time :stop, :trie => true, :using => :stop_datetime
    integer :category_id, :references => ::Category
    integer :municipality_id, :references => ::Municipality
    integer :organizer_id, :references => ::Organizer
    integer :syndicated_by_organizer_ids, :references => ::Organizer, :multiple => true
    integer :c1_id, :references => ::Category
    integer :c2_id, :references => ::Category
    integer :c3_id, :references => ::Category
  end
  handle_asynchronously :solr_index

  acts_as_gmappable
  
  def c1_id
    self.category.path_ids[1]
  end
  
  def c2_id
    self.category.path_ids[2]
  end

  def c3_id
    self.category.path_ids[3]
  end
  
  def syndicated_by_organizer_ids
    return self.syndicated_by_organizers.collect(&:id)
  end
  
  def category1
    Category.find(self.category.path_ids[1]).name unless self.category.path_ids[1].blank?
  end

  def category2
    Category.find(self.category.path_ids[2]).name unless self.category.path_ids[2].blank?
  end
  
  def category3  
    Category.find(self.category.path_ids[3]).name unless self.category.path_ids[3].blank?
  end
  
  has_attached_file :image1,
      :path => "events/:attachment/:id/:style/:filename",
      :default_url => "missing.jpg",
      :styles => {:medium => "384x384",
                  :small => "82x55#"}

  #process_in_background :image1

  def image1_url= url_str
    unless url_str.blank?
      unless url_str.split(':')[0] == 'http' || url_str.split(':')[0] == 'https'
          url_str = "http://" + url_str
      end
    end  
    write_attribute :image1_url, url_str
  end
  
  def normalize_file_names
    if !self.image1_file_name.nil?
      extension = File.extname(self.image1_file_name).gsub(/^\.+/, '')
      filename = File.basename(self.image1_file_name, ".#{extension}").parameterize
      self.image1.instance_write(:file_name, "#{filename}.#{extension}")
    end  
  end

  def image1_delete
    @image1_delete ||= "0"
  end

  def image1_delete=(value)
    @image1_delete = value
  end
  
  def gmaps= dummy=0
  end
  
  def gmaps
    0
  end
  
  def gmaps4rails_address
    "#{self.street}, Sverige" 
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
    duration = I18n.localize(start_datetime, :format => :longest)   
    unless  (self.start_datetime == self.stop_datetime)
      duration += "–"
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
      duration += "–"
      if self.start_date != self.stop_date
        duration += I18n.localize(stop_datetime, :format => :short)
      else
        duration += I18n.localize(stop_datetime, :format => :time)
      end
    end
    duration
  end

  
  def start_date
    return I18n.localize(@start_date, :format => :date) if @start_date.present?
    return I18n.localize(self.start_datetime, :format => :date) if self.start_datetime.present?
  end
  
  def start_time
    return I18n.localize(@start_time, :format => :time) if @start_time.present?
    return I18n.localize(self.start_datetime, :format => :time) if self.start_datetime.present?
  end 
  
  
  def start_date=(new_date)
    @start_date = Timeliness.parse(new_date)
  end
  
  
  def start_time=(new_time)
      @start_time = Timeliness.parse(new_time)  
  end


  def stop_date
    return I18n.localize(@stop_date, :format => :date) if @stop_date.present?
    return I18n.localize(self.stop_datetime, :format => :date) if self.stop_datetime.present?
    return I18n.localize(self.start_datetime, :format => :date) if self.start_datetime.present?
    return ""
  end
  
  def stop_time
    return I18n.localize(@stop_time, :format => :time) if @stop_time.present?
    return I18n.localize(self.stop_datetime, :format => :time) if self.stop_datetime.present?
    return I18n.localize(self.start_datetime, :format => :time) if self.start_datetime.present?
    return ""
  end 
  
  
  def stop_date=(new_date)
    @stop_date = Timeliness.parse(new_date)
  end
  
  
  def stop_time=(new_time)
    @stop_time = Timeliness.parse(new_time)
  end

  def future?
    false
  end
protected

  
  def merge_date_times
    if @start_date.present? && @start_time.present?
      self.start_datetime = Time.new(@start_date.year, @start_date.month, @start_date.day, @start_time.hour, @start_time.min)
      @stop_date = @start_date if @stop_date.blank? 
      @stop_time = @start_time if @stop_time.blank?
      self.stop_datetime = Time.new(@stop_date.year, @stop_date.month, @stop_date.day, @stop_time.hour, @stop_time.min)
    end
  end  


  def destroy_image1?
    if (@image1_delete == "1" )
      self.image1.clear 
      write_attribute :image1_caption, nil
      write_attribute :image1_url, nil
    end
  end
  
  def validates_start_stop  
    if errors.empty? && @start_date.present? && @start_time.present? && @stop_date.present? && @stop_time.present?
      if @start_date > @stop_date
        errors.add(:stop_date, I18n.t('error.messages.on_or_after', :restriction => I18n.localize(@start_date, :format => :date)))
      else
        if (@start_date == @stop_date) && (@start_time > @stop_time)
          errors.add(:stop_time, I18n.t('error.messages.on_or_after', :restriction => I18n.l(@start_time, :format => :time)))
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

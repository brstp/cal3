class Organizer < ActiveRecord::Base
  include ActionView::Helpers::UrlHelper
  has_many :events
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships
  
  attr_accessible :name, :description, :website, :user_ids, :logotype, :photo, :intro, :phone, :email
  
  validates_presence_of :name, :description
  validates_length_of :name, :in => 5..40
  validate :validates_website
  validates :phone, :phone => true
  validates :email, :email => true
  
  has_attached_file :logotype, :default_url => "/images/no-organizer-logotype.png", :styles => {:large => "400x300", :medium => "300x225", :small => "100x75"}
  has_attached_file :photo, :default_url => "/images/no-organizer-photo.png", :styles => {:medium => "400x300", :small => "100x75"}
  
#  searchable :auto_index => true, :auto_remove => true do
#    text :name
#    text :intro
#    text :description
#  end
  
  def to_s
    self.name
  end
  
  def ical
    c = Icalendar::Calendar.new
    #TODO Better way to point out url with helper (uid/url)
    for event in self.events.find(:all, :conditions => ["stop_datetime >= '#{Time.now}'"], :order => "start_datetime ASC") 
      c.add event.ical_single_event
    end
    c.publish
    c.to_ical
  end
  
  def upcoming_events
    self.events.find(:all, :conditions => ["stop_datetime >= '#{Time.now}'"], :order => "start_datetime ASC")   
  end

  def number_of_upcoming_events
    self.events.find(:all, :conditions => ["stop_datetime >= '#{Time.now}'"]).count
  end
  
  def next_event
    self.events.find(:all, :conditions => ["start_datetime >= '#{Time.now}'"], :order => "start_datetime ASC" ).first
  end
  
    
  def validates_website

    return 0 if self.website.blank?
    
    if self.website.match(URI::regexp(%w(http https))).nil?
      errors.add(:website, I18n.t('errors.messages.invalid_url'))
    end
  
  end
  
end

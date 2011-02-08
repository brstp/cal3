class Organizer < ActiveRecord::Base
  has_many :events
  
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships
  
  attr_accessible :name, :description, :website, :user_ids, :logotype, :photo, :intro
  
  validates_presence_of :name, :description
  validates_length_of :name, :in => 5..40
  validate :validates_website
  
  has_attached_file :logotype, :default_url => "/images/no-organizer-logotype.png", :styles => {:large => "300x225", :small => "100x75"}
  has_attached_file :photo, :default_url => "/images/no-organizer-photo.png", :styles => {:medium => "400x300", :small => "100x75"}
  
  
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

# encoding: UTF-8
class Organizer < ActiveRecord::Base
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::RawOutputHelper

  has_many :events
  
  has_many  :memberships, 
            :dependent => :destroy
 
  has_many  :users, 
            :through => :memberships
  
  has_many  :petitions, 
            :dependent => :destroy
            
  has_many  :petition_users, 
            :through => :petitions, 
            :source => :user  
  
  # has_many :admins, :through => :memberships, :source => :user, :conditions => "memberships.state = 'admin'"
  # has_many :applications, :through => :memberships, :source => :user, :conditions => "memberships.state = 'applied'"
  # has_many :nominees, :through => :memberships, :source => :user, :conditions => "memberships.state = 'nominated'"
  # has_many :user_infos, :through => :memberships, :source => :user, :conditions => "memberships.state = 'inform_admin'"
  
  

  
  attr_accessible :name, :description, :website, :user_ids, :logotype, :photo, :intro, :phone, :email
  
  validates_presence_of :name, :description, :email
  validates_length_of :name, :in => 5..40
  validate :validates_website
  validates :phone, :phone => true
  validates :email, :email => true
  
  has_attached_file :logotype, 
                    :storage => :s3,
                    :bucket => 'static.foreningskalendern.se',
                    :s3_credentials => {
                      :access_key_id => ENV['S3_KEY'],
                      :secret_access_key => ENV['S3_SECRET'] },
                    :default_url => "/images/organizer-logotype-90x109.png", 
                    :styles => {  
                      :medium => "90x109", 
                      :small => "45x55"}
                                    
  has_attached_file :photo,      
                    :storage => :s3,
                    :bucket => 'static.foreningskalendern.se',
                    :s3_credentials => {
                      :access_key_id => ENV['S3_KEY'],
                      :secret_access_key => ENV['S3_SECRET']},
                    :default_url => "/images/doldrums.jpg", 
                    :styles => {  
                      :medium => "360x240",  
                      :small => "176x117"}
  
  

  # has_attached_file :image1, 
      # :storage => :s3,
      # :bucket => 'static.foreningskalendern.se',
      # :s3_credentials => {
        # :access_key_id => ENV['S3_KEY'],
        # :secret_access_key => ENV['S3_SECRET']
                         # },
      # :default_url => "/images/blue-yellow-landscape.jpg", 
      # :styles => {:large => "800x600#", 
                  # :medium => "360x240#", 
                  # :small => "176x117#", 
                  # :thumb => "40x30#"}  


  
#  searchable :auto_index => true, :auto_remove => true do
#    text :name
#    text :intro
#    text :description
#  end
  
  def to_s
    self.name
  end
  
  def refresh_images # only used manually
    Organizer.all.each do |organizer|
      organizer.photo.reprocess!
    end
  end
  
  def relation_with user
    membership = self.memberships.find_by_user_id user.id
    if membership
      I18n.t("memberships.states.i_am.#{membership.state}")
    else
      ''
    end
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
  
  
  
  
  def past_events?
    !(self.events.find(:all, :conditions => ["stop_datetime < '#{Time.now}'"])).blank?
  end
  
  def future_events?
    !(self.events.find(:all, :conditions => ["stop_datetime >= '#{Time.now}'"])).blank?
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

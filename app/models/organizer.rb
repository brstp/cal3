# encoding: UTF-8
class Organizer < ActiveRecord::Base
  include ActionView::Helpers::UrlHelper
  #include ActionView::Helpers::AssetTagHelper
  #include ActionView::Helpers::RawOutputHelper

  has_many  :events,
            :dependent => :destroy
  
  has_many  :memberships, 
            :dependent => :destroy
 
  has_many  :users, 
            :through => :memberships
  
  has_many  :petitions, 
            :dependent => :destroy
            
  has_many  :petition_users, 
            :through => :petitions, 
            :source => :user  
  
  
  default_scope :order => 'name'

  extend FriendlyId
  friendly_id :name, :use => [:slugged, :history]

  
  before_save :destroy_photo? 
  before_save :destroy_logotype?
  attr_accessible :name, :description, :website, :photo_url, :photo_caption, :photo_delete, :logotype, :logotype_delete, :photo, :intro, :phone, :email, :human_name
  
  validates_presence_of :name, :description, :email
  validates_length_of :name, :in => 5..50, :allow_blank => true
  validates_length_of :photo_caption, :in => 0..60
  validates :phone, :phone => true
  validates :email, :email => true, :allow_blank => true  
  validates :website, :allow_blank => true, :uri => { :format => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix }
  validates :photo_url, :allow_blank => true, :uri => { :format => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix }
  
  image_store = ENV["RAILS_ENV"].to_s + "/" unless ENV["RAILS_ENV"] == "production"
    
  has_attached_file :logotype, 
                    :path => "#{image_store}app/public/system/:attachment/:id/:style/:filename",
                    :storage => :s3,
                    :bucket => 'static.allom.se',
                    :s3_credentials => {
                      :access_key_id => ENV['S3_KEY'],
                      :secret_access_key => ENV['S3_SECRET'] },
                    :default_url => "missing-organizer-logotype.png", 
                    :styles => {  
                      :medium => "600x200", 
                      :small => "270x90"}
  process_in_background :logotype

  has_attached_file :photo,      
                    :path => "#{image_store}app/public/system/:attachment/:id/:style/:filename",
                    :storage => :s3,
                    :bucket => 'static.allom.se',
                    :s3_credentials => {
                      :access_key_id => ENV['S3_KEY'],
                      :secret_access_key => ENV['S3_SECRET']},
                    :default_url => "missing-organizer.jpg", 
                    :styles => {  
                      :medium => "384x384" 
                                }  
  process_in_background :photo    
 
  def to_s
    self.name
  end
  
  def s
    if (self.name.split('').last.downcase == "s")
      self.name
    else
      self.name.strip + "s"  
    end
  end
  
  def contact_name
    if self.human_name.blank?
      self.email
    else
      self.human_name
    end
  end
  
  def photo_url= url_str
    unless url_str.blank?
      unless url_str.split(':')[0] == 'http' || url_str.split(':')[0] == 'https'
          url_str = "http://" + url_str
      end
    end  
    write_attribute :photo_url, url_str
  end

  def photo_delete
    @photo_delete ||= "0"
  end

  def photo_delete=(value)
    @photo_delete = value
  end

  
  def logotype_delete
    @logotype_delete ||= "0"
  end

  def logotype_delete=(value)
    @logotype_delete = value
  end

  
  def website= url_str
    unless url_str.blank?
      unless url_str.split(':')[0] == 'http' || url_str.split(':')[0] == 'https'
          url_str = "http://" + url_str
      end
    end  
    write_attribute :website, url_str
  end
  
  def default_municipality
    self.events.find( :all, 
                      :order => "created_at DESC" ).first.try :municipality
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


  def ical
    c = Icalendar::Calendar.new
    #TODO Better way to point out url with helper (uid/url)
    for event in self.events.find(:all, :conditions => ["stop_datetime >= '#{Time.now}'"], :order => "start_datetime ASC") 
      c.add event.ical_single_event
    end
    c.publish
    c.to_ical
  end
  
  def upcoming_events max_no = 99999
    self.events.find(:all, :conditions => ["stop_datetime >= '#{Time.now}'"], :order => "start_datetime ASC", :limit => max_no)   
  end
  
  def past_events max_no = 99999
    self.events.find(:all, :conditions => ["stop_datetime <= '#{Time.now}'"], :order => "start_datetime DESC", :limit => max_no)   
  end
  
  #def may_recruit? user
    # **** TODO ****
    # return true if user.blank?
    # return true if (!self.users.include? user) && (!self.petition_users.include? user)
    false
  #end
  
  
  def past_events?
    !(self.events.find(:all, :conditions => ["stop_datetime < '#{Time.now}'"])).blank?
  end
  
  def future_events?
    !(self.events.find(:all, :conditions => ["stop_datetime >= '#{Time.now}'"])).blank?
  end

  def number_of_upcoming_events
    self.events.find(:all, :conditions => ["stop_datetime >= '#{Time.now}'"]).count
  end

  def number_of_past_events
    self.events.find(:all, :conditions => ["stop_datetime < '#{Time.now}'"]).count
  end
  
  def next_event
    self.events.find(:all, :conditions => ["start_datetime >= '#{Time.now}'"], :order => "start_datetime ASC" ).first
  end
  
  protected
  
  def destroy_photo?
    if (@photo_delete == "1" )
      self.photo.clear 
      write_attribute :photo_caption, nil
      write_attribute :photo_url, nil
    end
  end

  def destroy_logotype?
    if (@logotype_delete == "1" )
      self.logotype.clear 
    end
  end
  
end

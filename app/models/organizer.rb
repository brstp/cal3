# encoding: UTF-8
class Organizer < ActiveRecord::Base
  include ActionView::Helpers::UrlHelper
  #include ActionView::Helpers::AssetTagHelper
  #include ActionView::Helpers::RawOutputHelper

  has_many  :events,
            :dependent => :destroy
            
  has_many  :upcoming_events,
            :class_name => 'Event',
            :conditions => "events.stop_datetime > '#{Time.now}'"

  has_many  :past_events,
            :class_name => 'Event',
            :conditions => "events.stop_datetime < '#{Time.now}'"
  
  has_many  :memberships, 
            :dependent => :destroy
 
  has_many  :users, 
            :through => :memberships
  
  has_many  :petitions, 
            :dependent => :destroy
            
  has_many  :petition_users, 
            :through => :petitions, 
            :source => :user  
  
  has_many  :syndications,
            :dependent => :destroy
            
  has_many  :syndicated_organizers,
            :through => :syndications
            
  has_many  :syndications_of_me, 
            :foreign_key => :syndicated_organizer_id,
            :class_name => 'Syndication',
            :dependent => :destroy
            
            
  has_many  :syndicated_by_organizers,
            :through => :syndications_of_me,
            :source => :organizer

  has_many  :syndicated_events,
            :through => :syndicated_organizers,
            :source => :upcoming_events
            
            
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
  validates_attachment_content_type :logotype, :content_type => /image/
  validates_attachment_size :logotype, :in => 0..10.megabytes
  validates_attachment_content_type :photo, :content_type => /image/
  validates_attachment_size :photo, :in => 0..10.megabytes
  

  has_attached_file :logotype, 
                    :default_url => "missing-organizer-logotype.png", 
                    :path => "/organizers/:attachment/:id/:style/:filename",
                    :styles => {  
                      :medium => "256x256", 
                      :small => "90x90"}
  #process_in_background :logotype

  has_attached_file :photo,      
                    :default_url => "missing-organizer.jpg", 
                    :path => "organizers/:attachment/:id/:style/:filename",
                    :styles => {  
                      :medium => "384x384" 
                                }  
  #process_in_background :photo    
 
  
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

# encoding: UTF-8
class Municipality < ActiveRecord::Base
  has_many :events
  attr_accessible :name, :short_name, :admin_no, :parent_admin_no, :facts, :wikipedia_page, :escutcheon
  validates_presence_of  :name, :short_name, :admin_no, :parent_admin_no
  validates_length_of :name, :in => 5..40
  validates_uniqueness_of :name, :short_name, :admin_no
  
  default_scope :order => 'name ASC'
  
  #searchable :auto_index => true, :auto_remove => true do
  #  text :name
  #end
  
  has_friendly_id :name, :use_slug => true

  
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
  
  def self.select_municipality
    municipality_array  = {}
    municipality_array[I18n.t('events.form.select_municipality')] = nil 
    for municipality in Municipality.find(:all, :order => "name ASC")
      municipality_array[municipality.name] = municipality.id 
    end
    municipality_array 
  end
  
  def upcoming_events max_no = 0
    
    if max_no > 0
      self.events.find(:all, :conditions => ["stop_datetime >= '#{Time.now}'"], :order => "start_datetime ASC", :limit => max_no)   
    else
      self.events.find(:all, :conditions => ["stop_datetime >= '#{Time.now}'"], :order => "start_datetime ASC")   
    end
    
  end

  def number_of_upcoming_events
    self.events.find(:all, :conditions => ["stop_datetime >= '#{Time.now}'"]).count
  end
  
  def next_event
    self.events.find(:all, :conditions => ["stop_datetime >= '#{Time.now}'"], :order => "start_datetime ASC" ).first
  end
  
end


  def select_organizer
    my_organizer = {}
    my_organizer[I18n.t('events.form.select_organizer')] = nil 
    for organizer in self.organizers
      my_organizer[organizer.name] = organizer.id 
    end
    my_organizer  
  end

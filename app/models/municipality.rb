class Municipality < ActiveRecord::Base
  has_many :events
  attr_accessible :name, :short_name, :admin_no, :parent_admin_no, :facts, :wikipedia_page
  validates_presence_of  :name, :short_name, :admin_no, :parent_admin_no
  validates_length_of :name, :in => 5..40
  validates_uniqueness_of :name, :short_name, :admin_no
  
  #searchable :auto_index => true, :auto_remove => true do
  #  text :name
  #end
  
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
  
end

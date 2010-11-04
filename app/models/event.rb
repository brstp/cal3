class Event < ActiveRecord::Base

   belongs_to :municipality

  attr_accessible :subject, :intro, :description, :start_time, :stop_time, :street, :zip, :city, :loc_descr, :lat, :lng, :municipality_id

  validates_presence_of :subject, :description, :start_time, :stop_time, :municipality
  validates_length_of :subject, :in => 10..40
  validates_length_of :intro, :in => 0..90
  validates_numericality_of :lat, :allow_nil => true
  validates_numericality_of :lng, :allow_nil => true
  validates_datetime :start_time, :allow_nil => false
  validates_datetime :stop_time, :allow_nil => false
  validates_datetime :stop_time, :after => :start_time, :after_message => "must be after start time"

end

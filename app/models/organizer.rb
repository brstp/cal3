class Organizer < ActiveRecord::Base
  has_many :events
  attr_accessible :name, :description, :website
  validates_presence_of :name, :description
  validates_length_of :name, :in => 8..40
  
  
  def my_events
    Event.where(:organizer_id => @id).all
  end
end

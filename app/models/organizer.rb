class Organizer < ActiveRecord::Base
  has_many :events
  attr_accessible :name, :description, :website
  validates_presence_of :name, :description
end

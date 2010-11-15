class Municipality < ActiveRecord::Base
  attr_accessible :name
  validates_presence_of :name
  validates_length_of :name, :in => 8..40
  validates_uniqueness_of :name
  
  
end

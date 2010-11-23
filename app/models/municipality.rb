class Municipality < ActiveRecord::Base
  has_many :events
  attr_accessible :name, :short_name, :admin_no, :parent_admin_no
  validates_presence_of  :name, :short_name, :admin_no, :parent_admin_no
  validates_length_of :name, :in => 5..40
  validates_uniqueness_of :name, :short_name, :admin_no
  
  def upcoming_events
    self.events.find :all 
  end
end

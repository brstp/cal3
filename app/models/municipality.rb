class Municipality < ActiveRecord::Base
  has_many :events
  attr_accessible :name, :short_name, :admin_id, :parent_admin_id
  validates_presence_of  :name, :short_name, :admin_id, :parent_admin_id
  validates_length_of :name, :in => 5..40
  validates_uniqueness_of :name, :short_name, :admin_id
end

# encoding: UTF-8

class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :organizer
  #attr_accessible :organizer_id,
  #                :user_id,
  #                :created_at,
  #                :updated_at

  validates :organizer_id, :presence => true, :uniqueness => { :scope => :user_id }  

end


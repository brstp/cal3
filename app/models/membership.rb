class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :organizer
  attr_accessible :organizer_id, :user_id, :is_personal
end

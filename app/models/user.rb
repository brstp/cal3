class User < ActiveRecord::Base
  attr_accessible :name, :email, :organizers_id
end

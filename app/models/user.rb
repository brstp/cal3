class User < ActiveRecord::Base
  has_many :memberships
  has_many :organizers, :through => :memberships
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :organizer_ids
  
  validates_presence_of :email

  def name
    output_str=""
    if self.first_name
      output_str += self.first_name
    end
    if self.last_name
      output_str += " " + self.last_name
    end
    if self.email
      output_str += " <" + self.email + ">"
    end
    output_str.strip
  end
  
  def is_admin?
    is_admin
  end
  
end

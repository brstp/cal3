class User < ActiveRecord::Base
  has_many :memberships
  has_many :organizers, :through => :membership
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name 
  
  validates_presence_of :email

  def name
    self.first_name + ' ' + self.last_name + ' <' + self.email + '>'
   
  end
  
  # def name= (name_str)
    # @first_name = name_str
  # end
end

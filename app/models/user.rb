# encoding: UTF-8
class User < ActiveRecord::Base
  has_many :memberships, :dependent => :destroy
  has_many :organizers, :through => :memberships
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :organizer_ids, :is_admin

  validates_presence_of :email
  validates :email, :email => true
  
  default_scope :order => 'email'

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
  
  def select_organizer
    my_organizer = {}
    my_organizer[I18n.t('events.form.select_organizer')] = nil 
    for organizer in self.organizers
      my_organizer[organizer.name] = organizer.id 
    end
    my_organizer  
  end

  def is_admin?
    is_admin
  end

  def authorized? organizer
    if organizers.include? organizer or is_admin?
      true
    else
      false
    end
  end

end

# encoding: UTF-8
class User < ActiveRecord::Base

  has_many  :memberships,
            :dependent => :destroy

  has_many  :organizers,
            :through => :memberships

  has_many  :petitions,
            :dependent => :destroy

  has_many  :petition_organizers,
            :through => :petitions,
            :source => :organizer
            
  has_many  :applications, 
            :through => :organizers,
            :source => :petitions
  
  has_many  :syndications,
            :through => :organizers


  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  #include Devise::Async::Model

 
  attr_accessible :first_name, :last_name, :name_required, :email, :password_confirmation, :password
  
  validates_presence_of :email
  validates :email, :email => true
  validates_presence_of :first_name, :last_name, :if => :name_required

  before_destroy :destroy_prospectships

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

  def human_name
    output_str=""
    if self.first_name
      output_str += self.first_name
    end
    if self.last_name
      output_str += " " + self.last_name
    end
    output_str.strip
  end


  def to_s
    name
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
    if self.organizers.include? organizer || self.is_admin?
      true
    else
      false
    end
  end

end

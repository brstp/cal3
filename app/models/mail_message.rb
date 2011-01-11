class MailMessage < ActiveRecord::Base
  validates_presence_of :from_first_name, :mail_body, :from_email
  
  attr_accessible :from_email, :to_email, :ip, :user_agent, :referer, :event_id, :mail_body, :from_first_name, :from_last_name, :to_name, :from_phone
  
  validates :from_phone, :phone => true
  validates :from_email, :email => true

# TODO
# If user adds contact details not known already (phone no), populate User.
# If person not registered, register.

  def mail_body
    @mail_body
  end
  
  def mail_body= msg_str
    @mail_body = msg_str
  end
  
  def from_first_name
    @from_first_name
  end
  
  def from_first_name= name_str
    @from_first_name = name_str
  end
  
  def from_last_name
    @from_last_name
  end
  
  def from_last_name= name_str
    @from_last_name = name_str
  end
  
  def to_name
    @to_name
  end
  
  def to_name= name_str
    @to_name = name_str
  end
  
  def from_phone
    @from_phone
  end
  
  def from_phone= phone_str
    @from_phone = phone_str
  end
  
  def from_name
    (@from_first_name + ' ' + @from_last_name).strip
  end
end
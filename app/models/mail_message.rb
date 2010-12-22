class MailMessage < ActiveRecord::Base
  validates_presence_of :from_first_name, :mail_message, :from_email
  
  attr_accessible :from_email, :to_email, :ip, :user_agent, :referer, :event_id, :mail_message, :from_first_name, :from_last_name, :to_name, :from_phone
  
  validates :from_phone, :phone => true
  validates :from_email, :email => true

  
  # def about_sender
    # @ip = request.remote_ip
    # @referer = request.headers["http_referer"]
    # @user_agent = request.headers["http_user_agent"]
  # end
  

  def mail_message
    @mail_message
  end
  
  def mail_message= msg_str
    @mail_message = msg_str
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
  
 
end

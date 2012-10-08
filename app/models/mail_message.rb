class MailMessage < ActiveRecord::Base
  validates_presence_of :from_first_name, :from_email, :mail_body

  attr_accessible :from_email, :to_email, :ip, :user_agent, :referer, :event_id, :organizer_id, :mail_body, :from_first_name, :from_last_name, :to_name, :from_phone, :current_page, :subject

  validates :from_phone, :phone => true
  validates :from_email, :email => true

  def to_name
    @to_name
  end

  def to_name= name_str
    @to_name = name_str
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

  def from_phone
    @from_phone
  end

  def from_phone= phone_str
    @from_phone = phone_str
  end

  def from_name
    "#{@from_first_name} #{@from_last_name}"
  end

end

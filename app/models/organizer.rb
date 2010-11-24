class Organizer < ActiveRecord::Base
  has_many :events
  
  has_many :memberships
  has_many :users, :through => :memberships
  
  attr_accessible :name, :description, :website, :user_ids
  
  validates_presence_of :name, :description
  validates_length_of :name, :in => 5..40
  validate :validates_website
  
  
  def upcoming_events
    self.events.all
  end


  
  def validates_website

    return 0 if self.website.blank?
    
    if self.website.match(URI::regexp(%w(http https))).nil?
      errors.add(:website, I18n.t('errors.messages.invalid_url'))
    end
  
  end
  
end




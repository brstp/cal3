class AlmanacDay < ActiveRecord::Base
  
  validates_presence_of  :name, :day, :month
  validates_uniqueness_of :name
  default_scope :order => 'name ASC'
  
  def to_s
    self.name
  end
  
  def AlmanacDay.names day
    AlmanacDay.where("day = ? AND month = ?", I18n.l(Time.zone.now, :format => :day_of_month).to_i, I18n.l(Time.zone.now, :format => :month_of_year).to_i).flatten.join(" ")
  end
    
end

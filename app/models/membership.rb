class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :organizer
  attr_accessible :organizer_id, :user_id, :is_personal
  
  # TODO, run as cron job
  def self.purge_prospects
  # Set period in configuration
  # Considering sending email to prospect user.
    prospectships = Membership.where("created_at < ? AND prospect_user_id NOT null", 
                  Time.now - 8.months )
    for prospectship in prospectships
      prospectship.destroy
    end
  end
end

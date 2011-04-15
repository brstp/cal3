class Petition < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :organizer
  belongs_to  :decision_made_by_user, 
              :class_name => 'User',
              :foreign_key => 'decision_made_by_user_id'
  
  attr_accessible :organizer_id,
                  :user_id,
                  :argumentation, 
                  :decision_made_by_user_id,
                  :rejected_reason,
                  :approved
  
  validates_presence_of :organizer, 
                        :user, 
                        :argumentation
  
  validates_presence_of :rejected_reason, 
                        :if => :rejected?

  validates_inclusion_of  :approved, 
                          :in => [true,false],
                          :on => :update,
                          :message => I18n.t('error_messages.petition.approved_blank')
  
  validates_uniqueness_of :organizer_id, 
                          :scope => :user_id, 
                          :message => I18n.t('error_messages.petition.already_applied')

  default_scope :order => 'created_at DESC'
  
  accepts_nested_attributes_for :user

  def rejected?
    self.approved == false
  end
  
  def belongs_to? user
  end
  
  def is_admin_for? user
  end
  
end

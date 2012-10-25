class Petition < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :organizer
  belongs_to  :decision_made_by_user,
              :class_name => 'User',
              :foreign_key => 'decision_made_by_user_id'


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

  validate :validates_duplicates_membership

  accepts_nested_attributes_for   :user
                                  # Formtastic nested forms need this

  def rejected?
    self.approved == false
  end

  def validates_duplicates_membership
    unless Membership.find_by_user_id_and_organizer_id(self.user_id, self.organizer_id ) == nil
      errors.add(:organizer_id, I18n.t('errors.messages.duplicates_membership'))
    end
  end

  def promote_to_membership
    if self.approved
      m = Membership.find_or_initialize_by_user_id_and_organizer_id self.user_id, self.organizer_id
      m.save!
    end
  end

end

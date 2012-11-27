class ChangeNameOfRejectedByIdOnPetition < ActiveRecord::Migration
  def self.up
      rename_column :petitions, :rejected_by_user_id, :decision_made_by_user_id
  end

  def self.down
      rename_column :petitions, :decision_made_by_user_id, :rejected_by_user_id
  end
end

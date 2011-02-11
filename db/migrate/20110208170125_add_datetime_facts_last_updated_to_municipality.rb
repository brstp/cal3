class AddDatetimeFactsLastUpdatedToMunicipality < ActiveRecord::Migration
  def self.up
    add_column :municipalities, :facts_last_updated, :datetime
  end

  def self.down
    remove_column :municipalities, :facts_last_updated
  end
end

class AddEscutcheonToMunicipality < ActiveRecord::Migration
  def self.up
    add_column :municipalities, :escutcheon, :string
  end

  def self.down
    remove_column :municipalities, :escutcheon
  end
end

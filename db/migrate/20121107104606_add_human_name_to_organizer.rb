class AddHumanNameToOrganizer < ActiveRecord::Migration
  def change
    add_column :organizers, :human_name, :string
  end
end

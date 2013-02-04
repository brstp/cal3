class AddApplicationUrlToEvent < ActiveRecord::Migration
  def change
    add_column :events, :application_url, :string
  end
end

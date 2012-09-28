class AddPriceAndRegisterToEvent < ActiveRecord::Migration
  def change
    add_column :events, :price, :string
    add_column :events, :register, :string
  end
end

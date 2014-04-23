class AddColumnsToServices < ActiveRecord::Migration
  def change
    add_column :services, :description, :text
    add_column :services, :price, :float
  end
end

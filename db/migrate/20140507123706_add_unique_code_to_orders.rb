class AddUniqueCodeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :uniqueCode, :string
  end
end

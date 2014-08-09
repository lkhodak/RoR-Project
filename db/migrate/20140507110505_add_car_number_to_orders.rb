class AddCarNumberToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :carNumber, :string
  end
end

class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.float :price
      t.datetime :requestDate
      t.datetime :confirmationDate
      t.string :status
      t.datetime :plannedDate
      t.references :user, index: true
      t.references :service, index: true

      t.timestamps
    end
    add_index :orders, :status
  end
end

class CreateCtos < ActiveRecord::Migration
  def change
    create_table :ctos do |t|
      t.string :name
      t.text :description
      t.text :address
      t.text :contacts
      t.text :schedule

      t.timestamps
    end
  end
end

class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.date :date
      t.datetime :start
      t.datetime :end
      t.references :cto
      t.timestamps
    end
  end
end

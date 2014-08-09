class AddLatitudeAndLongitudeToCto < ActiveRecord::Migration
  def change
    add_column :ctos, :latitude, :float
    add_column :ctos, :longitude, :float
  end
end

class AddCtoRefToServices < ActiveRecord::Migration
  def change
    add_reference :services, :cto, index: true
  end
end

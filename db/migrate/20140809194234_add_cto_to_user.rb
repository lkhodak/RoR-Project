class AddCtoToUser < ActiveRecord::Migration
  def change
    add_reference :users, :cto, index: true
  end
end

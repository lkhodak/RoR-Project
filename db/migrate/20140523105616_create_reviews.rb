class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :reviewText
      t.integer :mark
      t.references :user, index: true
      t.references :service, index: true
      t.references :cto, index: true
      t.timestamps
    end
  end
end

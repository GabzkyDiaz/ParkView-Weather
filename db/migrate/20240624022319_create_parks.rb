class CreateParks < ActiveRecord::Migration[7.1]
  def change
    create_table :parks do |t|
      t.string :name
      t.text :description
      t.string :location
      t.string :park_code

      t.timestamps
    end
  end
end

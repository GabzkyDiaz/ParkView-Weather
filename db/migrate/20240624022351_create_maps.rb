class CreateMaps < ActiveRecord::Migration[7.1]
  def change
    create_table :maps do |t|
      t.references :park, null: false, foreign_key: true
      t.string :map_url
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end

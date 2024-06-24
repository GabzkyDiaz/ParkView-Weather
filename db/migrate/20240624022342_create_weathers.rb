class CreateWeathers < ActiveRecord::Migration[7.1]
  def change
    create_table :weathers do |t|
      t.references :park, null: false, foreign_key: true
      t.float :temperature
      t.string :conditions
      t.string :forecast
      t.date :date

      t.timestamps
    end
  end
end

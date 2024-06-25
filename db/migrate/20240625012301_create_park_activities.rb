class CreateParkActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :park_activities do |t|
      t.references :park, null: false, foreign_key: true
      t.references :activity, null: false, foreign_key: true

      t.timestamps
    end
  end
end

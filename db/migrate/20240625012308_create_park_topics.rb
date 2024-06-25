class CreateParkTopics < ActiveRecord::Migration[7.1]
  def change
    create_table :park_topics do |t|
      t.references :park, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true

      t.timestamps
    end
  end
end

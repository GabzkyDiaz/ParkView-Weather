class AddStatesToParks < ActiveRecord::Migration[7.1]
  def change
    add_column :parks, :states, :string
  end
end

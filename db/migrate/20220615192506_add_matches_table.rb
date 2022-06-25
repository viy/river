class AddMatchesTable < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.integer :river_id
      t.integer :dest_id
      t.string :match_type

      t.timestamps
    end
  end
end

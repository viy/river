class AddRiversMatchers < ActiveRecord::Migration[7.0]
  def change
    remove_column :matches, :river_id
    remove_column :matches, :dest_id
    remove_column :matches, :match_type
    add_column :rivers, :match_id, :integer
    add_column :rivers, :match_type, :string
  end
end

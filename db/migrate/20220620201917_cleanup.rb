class Cleanup < ActiveRecord::Migration[7.0]
  def change
    add_column :rivers, :grade, :string
    remove_column :rivers, :put_in_geom
    remove_column :rivers, :take_out_geom
    remove_column :rivers, :dup_put_in_id
    remove_column :rivers, :dup_take_out_id
    add_index :rivers, :origin_id
    add_index :rivers, :source_id
    add_index :rivers, :match_id
    add_index :rivers, :river
  end
end

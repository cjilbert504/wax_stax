class AddColumnToVinylRecords < ActiveRecord::Migration
  def change
    add_column :vinyl_records, :user_id, :integer
  end
end

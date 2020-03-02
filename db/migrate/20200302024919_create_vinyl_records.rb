class CreateVinylRecords < ActiveRecord::Migration
  def change
    create_table :vinyl_records do |t|

      t.timestamps null: false
    end
  end
end

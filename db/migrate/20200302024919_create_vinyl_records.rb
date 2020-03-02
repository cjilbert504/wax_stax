class CreateVinylRecords < ActiveRecord::Migration
  def change
    create_table :vinyl_records do |t|
      t.string :artist
      t.string :album
      t.string :genre
      t.string :release_date
      t.timestamps null: false
    end
  end
end

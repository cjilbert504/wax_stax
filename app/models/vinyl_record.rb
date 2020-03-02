class VinylRecord < ActiveRecord::Base
    validates_presence_of :artist, :album, :genre, :release_date
    belongs_to :user
end

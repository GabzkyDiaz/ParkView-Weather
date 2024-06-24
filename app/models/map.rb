class Map < ApplicationRecord
  belongs_to :park

  validates :map_url, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
end

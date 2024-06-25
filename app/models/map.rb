class Map < ApplicationRecord
  belongs_to :park

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "latitude", "longitude", "map_url", "park_id", "updated_at"]
  end

  validates :map_url, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
end

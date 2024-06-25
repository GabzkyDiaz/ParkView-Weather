class ParkActivity < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    ["activity_id", "created_at", "id", "id_value", "park_id", "updated_at"]
  end

  belongs_to :park
  belongs_to :activity
end

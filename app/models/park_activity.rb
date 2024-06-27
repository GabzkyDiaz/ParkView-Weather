class ParkActivity < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    ["activity_id", "created_at", "id", "id_value", "park_id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["activity", "park"]
  end

  belongs_to :park
  belongs_to :activity

  validates :activity_id, presence: true
  validates :park_id, presence: true
end

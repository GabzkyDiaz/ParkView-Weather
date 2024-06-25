class Weather < ApplicationRecord
  belongs_to :park

  def self.ransackable_attributes(auth_object = nil)
    ["conditions", "created_at", "date", "forecast", "id", "id_value", "park_id", "temperature", "updated_at"]
  end

  validates :temperature, presence: true
  validates :conditions, presence: true
end

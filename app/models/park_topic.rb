class ParkTopic < ApplicationRecord
  belongs_to :park
  belongs_to :topic

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "park_id", "topic_id", "updated_at"]
  end

end

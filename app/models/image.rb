class Image < ApplicationRecord
  belongs_to :park

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "park_id", "source", "updated_at", "url"]
  end

  validates :url, presence: true
  validates :source, presence: true
end

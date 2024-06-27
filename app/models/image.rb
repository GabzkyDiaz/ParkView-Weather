class Image < ApplicationRecord
  belongs_to :park
  has_one_attached :photo

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "park_id", "source", "updated_at", "url"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["park", "photo_attachment", "photo_blob"]
  end

  validates :url, presence: true
  validates :source, presence: true
end

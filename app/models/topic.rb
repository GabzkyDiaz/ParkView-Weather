class Topic < ApplicationRecord
  has_many :park_topics
  has_many :parks, through: :park_topics

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "name", "updated_at"]
  end

  validates :name, presence: true, uniqueness: true
end

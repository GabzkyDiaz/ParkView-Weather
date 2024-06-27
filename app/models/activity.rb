class Activity < ApplicationRecord
  has_many :park_activities
  has_many :parks, through: :park_activities

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "name", "updated_at"]
  end

  validates :name, presence: true, uniqueness: true
end

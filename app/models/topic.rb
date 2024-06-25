class Topic < ApplicationRecord
  has_many :park_topics
  has_many :parks, through: :park_topics

  validates :name, presence: true, uniqueness: true
end

class Park < ApplicationRecord
  has_many :images, dependent: :destroy
  has_many :weathers, dependent: :destroy
  has_one :map, dependent: :destroy
  has_many :park_activities, dependent: :destroy
  has_many :activities, through: :park_activities
  has_many :park_topics, dependent: :destroy
  has_many :topics, through: :park_topics

  validates :name, presence: true
  validates :location, presence: true
end

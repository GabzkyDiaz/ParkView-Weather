class Park < ApplicationRecord
  has_many :images, dependent: :destroy
  has_many :weathers, dependent: :destroy
  has_one :map, dependent: :destroy

  validates :name, presence: true
  validates :location, presence: true
end

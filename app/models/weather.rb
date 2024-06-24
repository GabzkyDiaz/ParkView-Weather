class Weather < ApplicationRecord
  belongs_to :park

  validates :temperature, presence: true
  validates :conditions, presence: true
end

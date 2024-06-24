class Image < ApplicationRecord
  belongs_to :park

  validates :url, presence: true
  validates :source, presence: true
end

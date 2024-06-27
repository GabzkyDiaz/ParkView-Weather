class Park < ApplicationRecord
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true

  has_many :weathers, dependent: :destroy
  has_one :map, dependent: :destroy
  has_many :park_activities, dependent: :destroy
  has_many :activities, through: :park_activities
  has_many :park_topics, dependent: :destroy
  has_many :topics, through: :park_topics

  validates :name, presence: true
  validates :location, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["activities", "images", "map", "park_activities", "park_topics", "topics", "weathers"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "full_state_names", "id", "id_value", "latitude", "location", "longitude", "name", "park_code", "states", "updated_at"]
  end

  STATE_ABBREVIATIONS_TO_NAMES = {
    "AL" => "Alabama",
    "AK" => "Alaska",
    "AZ" => "Arizona",
    "AR" => "Arkansas",
    "CA" => "California",
    "CO" => "Colorado",
    "CT" => "Connecticut",
    "DE" => "Delaware",
    "FL" => "Florida",
    "GA" => "Georgia",
    "HI" => "Hawaii",
    "ID" => "Idaho",
    "IL" => "Illinois",
    "IN" => "Indiana",
    "IA" => "Iowa",
    "KS" => "Kansas",
    "KY" => "Kentucky",
    "LA" => "Louisiana",
    "ME" => "Maine",
    "MD" => "Maryland",
    "MA" => "Massachusetts",
    "MI" => "Michigan",
    "MN" => "Minnesota",
    "MS" => "Mississippi",
    "MO" => "Missouri",
    "MT" => "Montana",
    "NE" => "Nebraska",
    "NV" => "Nevada",
    "NH" => "New Hampshire",
    "NJ" => "New Jersey",
    "NM" => "New Mexico",
    "NY" => "New York",
    "NC" => "North Carolina",
    "ND" => "North Dakota",
    "OH" => "Ohio",
    "OK" => "Oklahoma",
    "OR" => "Oregon",
    "PA" => "Pennsylvania",
    "RI" => "Rhode Island",
    "SC" => "South Carolina",
    "SD" => "South Dakota",
    "TN" => "Tennessee",
    "TX" => "Texas",
    "UT" => "Utah",
    "VT" => "Vermont",
    "VA" => "Virginia",
    "WA" => "Washington",
    "WV" => "West Virginia",
    "WI" => "Wisconsin",
    "WY" => "Wyoming"
  }.freeze

  before_save :set_full_state_names

  def self.state_full_name(abbreviation)
    STATE_ABBREVIATIONS_TO_NAMES[abbreviation]
  end

  def set_full_state_names
    self.full_state_names = states.split(',').map { |abbr| Park.state_full_name(abbr) }.join(', ')
  end
end

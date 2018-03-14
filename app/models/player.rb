class Player < ActiveRecord::Base
  # belongs_to :game
  has_one :game
  validates :name, presence: true
  validates_associated :game
end

class Player < ActiveRecord::Base
  # belongs_to :game
  has_one :game
  validates :name, presence: true, uniqueness: true
  validates_associated :game
  validates_length_of :name, :minimum => 1
end

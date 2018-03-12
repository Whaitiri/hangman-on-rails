class Game < ActiveRecord::Base
  # has_many :players
  # has_one :player
  belongs_to :player
end

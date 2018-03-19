class Match < ApplicationRecord
  belongs_to :game1, :class_name => 'Game'
  belongs_to :game2, :class_name => 'Game'

  def self.new_match(game1, game2)
    match = Match.new
    match.game1 = game1
    match.game2 = game2
    return match
  end
end

class Game < ActiveRecord::Base
  ALL_LETTERS = 'abcdefghijklmnopqrstuvwxyz'.split('')
  # has_many :players
  # has_one :player
  belongs_to :player
  validates :player_id, presence: true

  def self.new_game
    game = Game.new
    game.word = generate_word
    game.current_guess = (game.word.split('').map {'_'}).join
    game.current_guesses = ""
    game.guesses_left = 7
    return game
  end

  def self.generate_word
    wordList = []
    File.open("/usr/share/dict/words").each do |line|
      line = line.strip
      if line.strip.length > 7 or line.strip.length < 3
        next
      elsif line[0].match(/^[A-Z]/)
        next
      else
        wordList << line.strip
      end
    end
    return wordList[rand(0...wordList.count)]
  end

  def remaining_letters
    return (ALL_LETTERS - self.current_guesses.split('')).join
  end

  def process_input(input)
    input = input.downcase
    self.current_guesses += input
    i = 0
    guess_fail = 0
    self.word.split('').each do |letter|
      if letter == input
        self.current_guess[i] = letter
      else
        guess_fail += 1
      end
      i += 1
    end

    if guess_fail >= i
      self.guesses_left -= 1
      return true
    else
      return false
    end
  end

  def summarize_game
    # puts "Summary for Game #{self.id}:"
    # puts "The word was #{self.word}"
    # puts "#{self.player.name}'s guesses:"
    # player.playerGuesses.each do |guess|
    #   print "#{guess} "
    # end
    # puts ""
    # puts "#{player.playerName}'s guess was #{player.playerWord.join} with #{player.playerGuess} guesses remaining"
    # puts ""
  end

end

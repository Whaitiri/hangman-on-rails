class Game < ActiveRecord::Base
  # has_many :players
  # has_one :player
  belongs_to :player

  def new_game
    self.word = Game.generate_word
    self.current_guess = (self.word.split('').map {'_'}).join
    self.current_guesses = ""
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

  def self.all_letters
    'abcdefghijklmnopqrstuvwxyz'
  end

  def remaining_letters
    return (Game.all_letters.split('') - self.current_guesses.split('')).join
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
      return true
    else
      return false
    end
  end

end

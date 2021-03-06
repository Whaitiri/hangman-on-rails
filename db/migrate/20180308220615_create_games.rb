class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.string :word
      t.string :current_guess
      t.string :current_guesses
      t.integer :guesses_left


      t.timestamps
    end
    add_reference(:games, :player, foreign_key: {to_table: :players})
  end
end

require 'set'
require 'byebug'
require_relative 'player'

class Game

  GHOST = 'GHOST'
  ALPHABET = 'abcdefghijklmnopqrstuvwxyz'
  DICTIONARY = Set.new(File.readlines('dictionary.txt').map(&:chomp))

  def initialize(*players)
    @fragment = ''
    @players = players
    @remaining = players
  end

  def current_player
    @remaining.first
  end

  def previous_player
    @remaining.last
  end

  def reset!
    @round_over = false
    @remaining_words = DICTIONARY
    @fragment = ''
  end

  def play
    loop do
      @players.each { |player| puts "\n #{player}: #{player.record} \n\n"}
      @remaining = @players.reject { |player| player.ghost? }
      puts "#{@remaining.length} players remaining."
      break if @remaining.length == 1
      reset!
      play_round
    end

    puts "#{@remaining.first} wins GHOST!"
  end

  def play_round
    until @round_over do
      take_turn
      next_player!
    end

    previous_player.lose!
    puts "\n#{previous_player} finished the word \"#{@fragment}!\""
  end

  def take_turn
    puts "#{@remaining_words.length} words left"
    puts "Current fragment is #{@fragment}"
    letter = current_player.guess
    until valid_play?(letter)
      notify_invalid_play
      letter = current_player.guess
    end

    @fragment += letter
    @round_over = true if DICTIONARY.include?(@fragment)
  end

  def next_player!
    @remaining.rotate!
  end

  def valid_play?(letter)
    letter.downcase!
    return false unless letter.length == 1 && ALPHABET.include?(letter)
    selected_words = @remaining_words.select { |word| word.start_with?(@fragment + letter) }
    return false if selected_words.empty?
    @remaining_words = selected_words
    true
  end

  def notify_invalid_play
    puts 'invalid letter choice'
  end

end

if __FILE__ == $PROGRAM_NAME
  Game.new(Player.new('A'), Player.new('B'), Player.new('C')).play
end

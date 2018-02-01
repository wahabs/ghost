class Player
  GHOST = 'GHOST'
  attr_reader :losses

  def initialize(name)
    @name = name
    @losses = 0
  end

  def guess
    puts "#{@name}, please guess a letter."
    gets.chomp
  end

  def to_s
    @name
  end

  def lose!
    @losses += 1
  end

  def record
    @losses.zero? ? '' : GHOST[0...@losses]
  end

  def ghost?
    @losses == GHOST.length  
  end
end

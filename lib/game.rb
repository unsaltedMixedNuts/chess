class Game
  attr_reader :board, :current_player, :players

  def initialize
    @board = Board.new
    @players = {
      white: HumanPlayer.new(:white),
      black: HumanPlayer.new(:black)
    }

    @current_player = :white
  end

  def play
  end

end

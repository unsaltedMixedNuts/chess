require_relative 'board'

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
    loop do
      break if board.checkmate?(current_player)
      players[current_player].play_turn(board)
      @current_player = (current_player == :white) ? :black : :white
    end

    puts board.render_board
    puts "Game over. #{current_player}.capitalize has been checkmated.  Nice game."
    nil
  end

end

class HumanPlayer
  VALID_COL_INPUTS = %w(A B C D E F G H)
  VALID_ROW_INPUTS = %w(1 2 3 4 5 6 7 8)
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def play_turn(board)
    puts board.render_board
    puts "Current player: #{color.capitalize}"
    puts "Please input the start and end positions of your move (e.g. 'F2, F3')."

    puts "Enter start position (e.g. 'F2')."
    start_pos = sanitize_user_input(gets.chomp)

    puts "Enter end position (e.g. 'F3')."
    end_pos = sanitize_user_input(gets.chomp)

    board.move(color, start_pos, end_pos)

    rescue StandardError => e
      puts "Error: #{e.message}"
      retry
  end

  def sanitize_user_input(input)
    unless VALID_COL_INPUTS.include?(input[0]) && VALID_ROW_INPUTS.include?(input[1])
      raise "Invalid input! Try again."
    end

    translate(input)
  end

  def translate(input)
    [VALID_COL_INPUTS.index(input[0]), input[1].to_i]
  end
end

if $PROGRAM_NAME == __FILE__
  game = Game.new
  game.play
end

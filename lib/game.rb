require 'colorize'
require_relative 'board'
require 'byebug'

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
    move_count = 0
    loop do
      break if move_count > 3 && board.checkmate?(current_player)
      players[current_player].play_turn(board)
      @current_player = (current_player == :white) ? :black : :white
      move_count += 1
    end

    puts board.render_board
    puts "Nice game!"
    puts"#{current_player.capitalize} has been checkmated."
    puts"#{[:white, :black].reject{ |color| color == current_player }.join.capitalize} wins!\n\n\n"
    nil
  end

end

class HumanPlayer
  VALID_COL_INPUTS = %w(A B C D E F G H)
  VALID_ROW_INPUTS = [1, 2, 3, 4, 5, 6 ,7, 8]
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def play_turn(board)
    puts board.render_board
    font_color = color == :white ? :light_white : :black
    background = color == :white ? :black : :light_white
    print "Current player: ".colorize(:red)
    puts " #{color.capitalize} ".colorize(color: font_color, background: background)

    puts "Enter start position of your move (e.g. 'F2').".colorize(:red)
    # debugger
    start_pos = sanitize_user_input(gets.chomp)
    # puts "\nStart position is #{start_pos}.\nPiece at that spot is #{board[start_pos]} and color is #{board[start_pos].color}\n"
    # puts "Moves are #{board[start_pos].moves}\n"

    puts "Enter end position of your move (e.g. 'F3').".colorize(:red)
    end_pos = sanitize_user_input(gets.chomp)
    # puts "\nEnd position is #{end_pos}.\n"

    board.move(color, start_pos, end_pos)

    rescue StandardError => e
      puts "Error: #{e.message}"
      retry
  end

  def sanitize_user_input(input)
    input[0] = input[0].upcase
    unless VALID_COL_INPUTS.include?(input[0]) && VALID_ROW_INPUTS.include?(input[1].to_i)
      raise "Invalid input! Try again.".colorize(background: :light_red)
    end

    translate(input)
  end

  def translate(input)
    [input[1].to_i - 1, VALID_COL_INPUTS.index(input[0])]
  end
end

if $PROGRAM_NAME == __FILE__
  game = Game.new
  game.play
end

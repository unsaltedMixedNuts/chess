require_relative 'board'
require 'colorize'

class Game
  attr_reader :board, :current_player, :players

  def initialize
    @board = Board.new
    @players = { white: HumanPlayer.new(:white), black: HumanPlayer.new(:black) }
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

    game_over
  end

  def game_over
    puts board.render_board
    puts "Nice game!".colorize(*Board::SUCCESS_FORMATTING)

    puts"#{current_player.capitalize} is checkmated."
      .colorize(*Board::INSTRUCTION_FORMATTING)

    puts"#{[:white, :black]
      .reject{ |color| color == current_player }.join.capitalize} wins!"
      .colorize(*Board::INSTRUCTION_FORMATTING)

    puts"\n\n"
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

    puts "--#{color.capitalize} king in check--"
      .colorize(*Board::IN_CHECK_FORMATTING) if board.in_check?(color)

    give_user_instructions
    start_input, start_pos = get_user_start_pos(board)
    end_input, end_pos = get_user_end_pos(board, start_input, start_pos)

    board.move(color, start_pos, end_pos)

    print "Successfully moved #{board[end_pos].class.to_s.downcase}"
      .colorize(*Board::SUCCESS_FORMATTING)
    puts " from #{start_input} to #{end_input}."
      .colorize(*Board::SUCCESS_FORMATTING)

    rescue StandardError => e
      puts "Error: #{e.message}"
      retry
  end

  def player_font_and_background_colors
    font_color = color == :white ? :light_white : :black
    background = color == :white ? :black : :light_white
    formatting = [color: font_color, background: background]
  end

  def give_user_instructions
    print "Current player: ".colorize(*Board::INSTRUCTION_FORMATTING)
    puts " #{color.capitalize} ".colorize(*player_font_and_background_colors)
    puts "Enter position of piece to move (e.g. 'F2')."
      .colorize(*Board::INSTRUCTION_FORMATTING)
    nil
  end

  def get_user_start_pos(board)
    start_input = gets.chomp[0..1]
    start_pos = sanitize_user_input(start_input)

    if board.empty?(start_pos)
      raise "Invalid start position. Square #{start_input} is empty."
        .colorize(*Board::ERROR_FORMATTING)
    elsif board[start_pos].color != color
      raise "Invalid entry. Must move #{color} piece."
        .colorize(*Board::ERROR_FORMATTING)
    end

    [start_input, start_pos]
  end

  def get_user_end_pos(board, start_input, start_pos)
    print "Enter destination for #{start_input}'s #{color} "
      .colorize(*Board::INSTRUCTION_FORMATTING)
    puts"#{board[start_pos].class.to_s.downcase} (e.g. 'F3')."
      .colorize(*Board::INSTRUCTION_FORMATTING)

    end_input = gets.chomp[0..1]
    end_pos = sanitize_user_input(end_input)

    [end_input, end_pos]
  end

  def sanitize_user_input(input)
    input[0] = input[0].upcase

    unless VALID_COL_INPUTS.include?(input[0]) && VALID_ROW_INPUTS.include?(input[1].to_i)
      raise "Invalid input! Try again.".colorize(*Board::ERROR_FORMATTING)
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

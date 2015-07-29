require 'byebug'
require_relative 'piece'
require_relative 'stepping_pieces'

class Pawn < SteppingPieces
  def display_images
    { white: '♙', black: '♟' }
  end

  def moves
    forward_moves + kill_moves
  end

  def first_move?
    pos[0] == ((color == :white) ? Board::BLACK_PAWN_ROW : Board::WHITE_PAWN_ROW)
  end

  def forward_dir
    (color == :black) ? -1 : 1
  end

  def forward_moves
    # debugger
    x, y = pos
    single_step = [x, y + forward_dir]
    puts "Pos is #{pos} and single_step is #{single_step}"
    return [] unless board.valid_pos?(single_step) && board.empty?(single_step)

    possible_steps = [single_step]
    double_step = [x, y + 2 * forward_dir]
    possible_steps << double_step if first_move? && board.empty?(double_step)
    possible_steps
  end

  def kill_moves
    x, y = pos

    possible_kill_moves = [[x - 1, y + forward_dir], [x + 1, y + forward_dir]]

    possible_kill_moves.select do |pos|
      next false unless board.valid_pos?(pos)

      victim = board[pos]
      victim && victim.color != color
    end
  end

end

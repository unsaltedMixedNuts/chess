require 'colorize'
class Piece
  attr_reader :board, :color
  attr_accessor :pos

  COLORS = [:white, :black]

  def initialize(color, board, pos)
    raise 'invalid color'.colorize(background: :light_red) unless COLORS.include?(color)
    raise 'invalid position'.colorize(background: :light_red) unless board.valid_pos?(pos)

    @color, @board, @pos = color, board, pos
    board.add_piece_to_board(self, pos)
  end

  def render
    display_images[color]
  end

  def display_images
    raise NotImplementedError
  end

  def moves
    raise NotImplementedError
  end

  def valid_moves
    moves.reject { |pos| move_into_check?(pos) }
  end

  def move_into_check?(end_pos)
    board_clone = board.dup
    board_clone.move!(pos, end_pos)
    board_clone.in_check?(color)
  end

  def inspect
    "\n#{self.color.capitalize} #{self.class} at #{self.pos} (i.e. #{HumanPlayer::VALID_COL_INPUTS[self.pos[1]]}#{self.pos[0]+1})"
  end

end

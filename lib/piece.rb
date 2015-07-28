class Piece
  attr_reader :board, :color
  attr_accessor :pos

  COLORS = [:white, :black]

  def initialize(color, board, pos)
    raise 'invalid color' unless COLORS.include(color)
    raise 'invalid position' unless board.valid_pos?(pos)

    @color, @board, @pos = color, board, pos
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
    board_clone.move_piece!(pos, end_pos)
    board_clone.in_check?(color)
  end

end

class Piece

  def initialize(color, board, pos)
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

  end

  def move_into_check?(to_pos)
  end

end

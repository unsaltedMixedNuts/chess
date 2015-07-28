class Rook < SlidingPiece
  def move_dirs
    HORIZONTAL_DIRS
  end

  def display_images
    { white: '♖', black: '♜' }
  end
end

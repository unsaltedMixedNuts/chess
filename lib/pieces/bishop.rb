class Bishop < SlidingPiece
  def move_dirs
    DIAGONAL_DIRS
  end

  def display_images
    { white: '♗', black: '♝' }
  end
end

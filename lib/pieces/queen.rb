class Queen < SlidingPiece
  def move_dirs
    HORIZONTAL_DIRS + DIAGONAL_DIRS
  end

  def display_images
    { white: '♕', black: '♛' }
  end
end

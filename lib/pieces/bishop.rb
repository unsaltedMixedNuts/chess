require_relative 'piece'
require_relative 'sliding_pieces'

class Bishop < SlidingPiece
  def move_dirs
    DIAGONAL_DIRS
  end

  def display_images
    { white: '♗', black: '♝' }
  end
end

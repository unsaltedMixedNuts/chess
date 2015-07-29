require_relative 'piece'
require_relative 'sliding_pieces'

class Rook < SlidingPiece
  def move_dirs
    HORIZONTAL_DIRS
  end

  def display_images
    { white: '♖', black: '♜' }
  end
end

require_relative 'piece'
require_relative 'stepping_pieces'

class Knight < SteppingPieces

  def display_images
    { white: '♘', black: '♞' }
  end

  def stepping_moves
    [[-2, -1],
     [-1, -2],
     [-2, 1],
     [-1, 2],
     [1, -2],
     [2, -1],
     [1, 2],
     [2, 1]]
  end
end

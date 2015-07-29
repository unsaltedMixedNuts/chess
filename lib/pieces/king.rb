require_relative 'piece'
require_relative 'stepping_pieces'

class King < SteppingPieces

  def display_images
    { white: '♔', black: '♚' }
  end

  def stepping_moves
    [[-1, -1],
     [-1, 0],
     [-1, 1],
     [0, -1],
     [0, 1],
     [1, -1],
     [1, 0],
     [1, 1]]
  end
end

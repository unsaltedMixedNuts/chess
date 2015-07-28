class SlidingPiece < Piece
  HORIZONTAL_DIRS = [ [-1, 0], [0, -1], [0, 1], [1, 0] ]
  DIAGONAL_DIRS = [ [-1, -1], [-1, 1], [1, -1], [1, 1] ]

  def moves
    moves = []

    move_dirs.each do |dir_x, dir_y|
      moves.concat(get_valid_dir_moves(dir_x, dir_y))
    end

    moves
  end

  def get_valid_dir_moves(dir_x, dir_y)
    cur_x, cur_y = pos
    moves = []

    loop do
      cur_x += dir_x
      cur_y += dir_y
      pos = (cur_x, cur_y)

      break unless board.valid_pos(pos)

      if board.empty?(pos)
        moves << pos
      else
        moves << pos unless board[pos] == color
        break
      end
    end

    moves
  end

end

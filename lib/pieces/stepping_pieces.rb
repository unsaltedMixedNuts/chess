class SteppingPieces < Piece
  def moves
    stepping_moves.each_with_object([]) do | (dir_x, dir_y), moves|
      cur_x, cur_y = pos
      pos = [cur_x + dir_x, cur_y + dir_y]

      if board.valid_pos?(pos)

        if board.empty?(pos)
          moves << pos
        else
          moves << pos unless board[pos].color == color
        end
      end
    end
  end
end

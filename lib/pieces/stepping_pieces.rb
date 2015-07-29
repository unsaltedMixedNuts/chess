class SteppingPieces < Pieces
  def moves
    stepping_moves.each_with_object([]) do | (dir_x, dir_y), moves|
      cur_x, cur_y = pos
      pos = [cur_x + dir_x, cur_y + dir_y]

      if board.valid_move?(pos)

        if board.empty?(pos)
          moves << pos
        else
          moves << pos unless board[pos].color == color
        end
      end
    end
  end

end

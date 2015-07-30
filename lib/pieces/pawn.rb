class Pawn < SteppingPieces
  def display_images
    { white: '♙', black: '♟' }
  end

  def moves
    forward_moves + kill_moves
  end

  def first_move?
    pos[0] == ((color == :black) ? Board::BLACK_PAWN_ROW : Board::WHITE_PAWN_ROW)
  end

  def forward_dir
    (color == :black) ? -1 : 1
  end

  def forward_moves
    x, y = pos
    single_step = [x + forward_dir, y]
    return [] unless board.valid_pos?(single_step) && board.empty?(single_step)
    possible_steps = [single_step]
    double_step = [x + 2 * forward_dir, y]
    possible_steps << double_step if first_move? && board.empty?(double_step)
    possible_steps
  end

  def kill_moves
    x, y = pos
    possible_kill_moves = [[x + forward_dir, y - 1], [x + forward_dir, y + 1]]

    possible_kill_moves.select do |pos|
      next false unless board.valid_pos?(pos)
      victim = board[pos]
      victim && victim.color != color
    end
  end
end

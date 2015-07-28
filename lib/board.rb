class Board
  BOARD_DIMENSIONS = 8
  BLACK_PAWN_ROW = 6
  BLACK_NON_PAWN_ROW = 7
  WHITE_PAWN_ROW = 1
  WHITE_NON_PAWN_ROW = 0

  def initialize
    populate_board
  end

  def [](pos)
    raise 'invalid position' unless valid_pos?(pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos, piece)
    raise 'invalid position' unless valid_pos?(pos)
    row, col = pos
    @board[row][col] = piece
  end

  def empty?(pos)
    self[pos].nil?
  end

  def move(current_color, start_pos, end_pos)
    raise 'start position is empty' if empty?(start_pos)

    piece = self[start_pos]

    if piece.color != current_color
      raise "invalid move; must move #{current_color}'s piece this turn"
    elsif !piece.moves.include?(to_pos)
      raise "invalid move; piece can't move that way"
    elsif !piece.valid_moves.include?(end_pos)
      raise "invalid move; cannot move into check"
    end

    move!(start_pos, end_pos)
  end

  def move!(start_pos, end_pos)
    piece = self[start_pos]

    self[start_pos] = piece
    self[end_pos] = nil
    piece.pos = end_pos
    piece.first_move = false if piece.class == Pawn
  end

  def pieces_on_board
    @board.flatten.compact
  end

  def in_check?(color)
    king_pos = get_king_pos(color)

    pieces_on_board.any? do |piece|
      piece.color != color && piece.moves.include(king_pos)
    end
  end

  def get_king_pos(color)
    pieces_on_board.each do |piece|
      return piece.pos if piece.color == color && piece.class('King')
    end

    raise 'king peice not found on board'
  end

  def populate_board
    @board = Array.new(BOARD_DIMENSIONS) { Array.new(BOARD_DIMENSIONS) }

    Piece::COLORS.each do |color|
      insert_pawns(color)
      insert_non_pawns(color)
    end

    nil
  end

  def insert_pawns(color)
    row_idx = color == :black ? BLACK_PAWN_ROW : WHITE_PAWN_ROW
    BOARD_DIMENSIONS.times { |col_idx| Pawn.new(color, self, [row_idx, col_idx]) }
  end

  def insert_non_pawns(color)
    pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    row_idx = color == :black ? BLACK_NON_PAWN_ROW : WHITE_NON_PAWN_ROW

    pieces.each_with_index do |peice_class, col_idx|
      peice_class.new(color, self, [row_idx, col_idx])
    end
  end

end

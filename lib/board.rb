require 'byebug'
require_relative 'pieces'
require 'colorize'

class Board
  BOARD_DIMENSIONS = 8
  BLACK_PAWN_ROW = 6
  BLACK_NON_PAWN_ROW = 7
  WHITE_PAWN_ROW = 1
  WHITE_NON_PAWN_ROW = 0

  def initialize(setup_board = true)
    @board = Array.new(BOARD_DIMENSIONS) { Array.new(BOARD_DIMENSIONS) }
    populate_board if setup_board
  end

  def populate_board
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

    pieces.each_with_index do |piece_class, col_idx|
      piece_class.new(color, self, [row_idx, col_idx])
    end
  end

  def add_piece_to_board(piece, pos)
    raise 'position not empty' unless empty?(pos)
    self[pos] = piece
  end

  def empty?(pos)
    self[pos].nil?
  end

  def valid_pos?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def move(current_color, start_pos, end_pos)
    raise 'start position is empty' if empty?(start_pos)

    piece = self[start_pos]

    # debugger
    if piece.color != current_color
      raise "invalid move; must move #{current_color}'s piece this turn".colorize(background: :light_red)
    elsif !piece.moves.include?(end_pos)
      raise "invalid move; piece can't move that way".colorize(background: :light_red)
    elsif !piece.valid_moves.include?(end_pos)
      raise "invalid move; cannot move into check".colorize(background: :light_red)
    end

    move!(start_pos, end_pos)
  end

  def move!(start_pos, end_pos)
    piece = self[start_pos]

    self[end_pos] = piece
    self[start_pos] = nil
    piece.pos = end_pos
  end

  def pieces_on_board
    @board.flatten.compact
  end

  def in_check?(color)
    king_pos = get_king_pos(color)

    pieces_on_board.any? do |piece|
      piece.color != color && piece.moves.include?(king_pos)
    end
  end

  def checkmate?(color)
    return false unless in_check?(color)

    pieces_on_board.select { |piece| piece.color == color}.all? do |piece|
      piece.valid_moves.empty?
    end
  end

  def get_king_pos(color)
    pieces_on_board.each do |piece|
      return piece.pos if piece.color == color && piece.is_a?(King)
    end

    raise 'king peice not found on board'.colorize(background: :light_red)
  end

  def dup
    duplicate = Board.new(false)

    pieces_on_board.each do |piece|
      piece.class.new(piece.color, duplicate, piece.pos)
    end

    duplicate
  end



  def render_board
    # # -----DEBUGGING LABELS -----
    # letters = "   0 1 2 3 4 5 6 7"
    # # -----DEBUGGING LABELS -----

    # -----NORMAL LABELS -----
    letters = "   A B C D E F G H"
    # -----NORMAL LABELS -----

    rendering = "\n\n\n--- Chess by Mel ---"
    rendering << "\n" + letters.dup
    descending_nums = (1..BOARD_DIMENSIONS).to_a.reverse
    descending_nums.each do |col|

      # # -----DEBUGGING LABELS -----
      # rendering << "\n#{col-1} "
      # # -----DEBUGGING LABELS -----

      # -----NORMAL LABELS -----
      rendering << "\n#{col} "
      # -----NORMAL LABELS -----

      BOARD_DIMENSIONS.times do |row|
        spot_render = self[[col - 1, row]].nil? ? "  " : " #{self[[col - 1, row]].render}"
        color = (row + col - 1).even? ? :on_cyan : :on_light_white

        rendering << spot_render.send(color)

      end

      # # -----DEBUGGING LABELS -----
      # rendering << " #{col}"
      # # -----DEBUGGING LABELS -----

      # -----NORMAL LABELS -----
      rendering << " #{col}"
      # -----NORMAL LABELS -----

    end
    # # -----DEBUGGING LABELS -----
    # rendering << "\n" + "   A B C D E F G H"
    # # -----DEBUGGING LABELS -----

    # -----NORMAL LABELS -----
    rendering << "\n" + letters
    # -----NORMAL LABELS -----


    puts rendering
    # debugger
  end

  def [](pos)
    raise 'invalid position'.colorize(background: :light_red) unless valid_pos?(pos)
    row, col = pos
    # debugger if pos = [1,5]
    @board[row][col]
  end

  def []=(pos, piece)
    raise 'invalid position'.colorize(background: :light_red) unless valid_pos?(pos)
    row, col = pos
    @board[row][col] = piece
  end

end

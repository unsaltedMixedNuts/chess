require_relative 'pieces'
require 'colorize'

class Board
  BOARD_DIMENSIONS = 8
  BLACK_PAWN_ROW = 6
  BLACK_NON_PAWN_ROW = 7
  WHITE_PAWN_ROW = 1
  WHITE_NON_PAWN_ROW = 0
  PIECES = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
  ERROR_FORMATTING = [background: :light_red]
  SUCCESS_FORMATTING = [color: :light_white, background: :green]
  INSTRUCTION_FORMATTING = [:red]
  IN_CHECK_FORMATTING = [color: :black, background: :light_red ]

  def initialize(setup_board = true)
    @board = Array.new(BOARD_DIMENSIONS) { Array.new(BOARD_DIMENSIONS) }
    populate_board if setup_board
  end

  #Call Board#custom_board inside of Board#initialize instead of calling...
  #...Board#populate_board in order to simulate a specific board configuration.
  def custom_board
    # Input custom board and piece configuration inside this method for simulation.
    Bishop.new(:black, self, [1, 5])
    Bishop.new(:black, self, [2, 5])
    King.new(:black, self, [3, 6])
    King.new(:white, self, [1, 7])
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
    nil
  end

  def insert_non_pawns(color)
    row_idx = color == :black ? BLACK_NON_PAWN_ROW : WHITE_NON_PAWN_ROW

    PIECES.each_with_index do |piece_class, col_idx|
      piece_class.new(color, self, [row_idx, col_idx])
    end

    nil
  end

  def add_piece_to_board(piece, pos)
    raise 'Position not empty'.colorize(*ERROR_FORMATTING) unless empty?(pos)
    self[pos] = piece
  end

  def empty?(pos)
    self[pos].nil?
  end

  def valid_pos?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def move(current_color, start_pos, end_pos)
    raise 'Start position is empty'.colorize(*ERROR_FORMATTING) if empty?(start_pos)

    piece = self[start_pos]

    if piece.color != current_color
      raise "Invalid entry. Must move #{color} piece."
        .colorize(*ERROR_FORMATTING)
    elsif !piece.moves.include?(end_pos)
      raise "Invalid move.  Piece does not move that way."
        .colorize(*ERROR_FORMATTING)
    elsif !piece.valid_moves.include?(end_pos)
      raise "Invalid move.  Moving into check is not allowed."
        .colorize(*ERROR_FORMATTING)
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
    #Must check for checkmate even if no player is currently in check because...
    #towards end of a game a player can have no valid moves that will not put...
    #himself in check.
    pieces_on_board.select { |piece| piece.color == color}.all? do |piece|
      piece.valid_moves.empty?
    end
  end

  def get_king_pos(color)
    pieces_on_board.each do |piece|
      return piece.pos if piece.color == color && piece.is_a?(King)
    end

    raise 'King peice not found on board'.colorize(*ERROR_FORMATTING)
  end

  def dup
    duplicate = Board.new(false)

    pieces_on_board.each do |piece|
      piece.class.new(piece.color, duplicate, piece.pos)
    end

    duplicate
  end



  def render_board
    letters = "   A B C D E F G H"
    rendering = "\n\n\n--- Chess by Mel ---"
    rendering << "\n" + letters.dup
    descending_nums = (1..BOARD_DIMENSIONS).to_a.reverse

    descending_nums.each do |col|
      rendering << "\n#{col} "

      BOARD_DIMENSIONS.times do |row|
        spot_render = self[[col - 1, row]].nil? ? "  " : " #{self[[col - 1, row]].render}"
        color = (row + col - 1).even? ? :on_cyan : :on_light_white
        rendering << spot_render.send(color)
      end

      rendering << " #{col}"
    end

    rendering << "\n" + letters
    puts rendering
  end

  def [](pos)
    raise 'Invalid position'.colorize(*ERROR_FORMATTING) unless valid_pos?(pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos, piece)
    raise 'Invalid position'.colorize(*ERROR_FORMATTING) unless valid_pos?(pos)
    row, col = pos
    @board[row][col] = piece
  end
end

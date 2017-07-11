require_relative 'board'
require 'byebug'

module SlidingPiece

  def moves
    horizontal_moves = []
    vertical_moves = []
    diagonal_moves = []

    if self.directions.include?(:vertical)
      vertical_moves = []
      (0..7).each do |num|
        vertical_moves << [self.position[0], num] unless num == self.position[1]
      end
    end
    if self.directions.include?(:horizontal)
      horizontal_moves = []
      (0..7).each do |num|
        horizontal_moves << [num, self.position[1]] unless num == self.position[0]
      end
    end
    if self.directions.include?(:diagonal)
      diagonal_moves = []
      (1..7).each do |num|
        diagonal_moves << [(self.position[0]) + num, (self.position[1]) + num]#downright
        diagonal_moves << [(self.position[0]) + num, (self.position[1]) - num]#upright
        diagonal_moves << [(self.position[0]) - num, (self.position[1]) + num]#downleft
        diagonal_moves << [(self.position[0]) - num, (self.position[1]) - num]#upleft
      end
      diagonal_moves.reject! { |move| move[0] < 0 || move[0] > 7 || move[1] < 0 || move[1] > 7 }
    end

    board = self.board.board
    diagonal_dupe = diagonal_moves.dup
    diagonal_moves.each do |move|
      piece = board[move[0]][move[1]]
      # next if piece == nil
      # up right
      if move[1] > self.position[1] && move[0] > self.position[0] && piece != nil
        diagonal_dupe.reject! do |move|
          if piece.color != self.color
            move[1] > piece.position[1] && move[0] > piece.position[0]
          else
            move[1] >= piece.position[1] && move[0] >= piece.position[0]
          end
        end
      end
      #up left
      if move[1] > self.position[1] && move[0] < self.position[0] && piece != nil
        diagonal_dupe.reject! do |move|
          if piece.color != self.color
            move[1] > piece.position[1] && move[0] < piece.position[0]
          else
            move[1] >= piece.position[1] && move[0] <= piece.position[0]
          end
        end
      end
      #down left
      if move[1] < self.position[1] && move[0] < self.position[0] && piece != nil
        diagonal_dupe.reject! do |move|
          if piece.color != self.color
            move[1] < piece.position[1] && move[0] < piece.position[0]
          else
            move[1] <= piece.position[1] && move[0] <= piece.position[0]
          end
        end
      end
      #down right
      if move[1] < self.position[1] && move[0] > self.position[0] && piece != nil
        diagonal_dupe.reject! do |move|
          if piece.color != self.color
            move[1] < piece.position[1] && move[0] > piece.position[0]
          else

            move[1] <= piece.position[1] && move[0] >= piece.position[0]
          end
        end
      end

    end

    #vertical
      # if position is below self and position holds a piece
        #eliminate all y greater than current position y
      #end
      #if position is above self and position holds a piece
        #eliminate all y less than current position y
      #end
    vertical_dupe = vertical_moves.dup

    vertical_moves.each do |move|
      piece = board[move[0]][move[1]]
      if move[1] > self.position[1] && piece != nil # if position is below self and position holds a piece
        vertical_dupe.reject! do |move|
          if piece.color != self.color
            move[1] > piece.position[1]  #eliminate all y greater than current position y, we can take it
          else
            move[1] >= piece.position[1] #we can't take cause friendly
          end
        end
      end
      if move[1] < self.position[1]  && piece != nil #if position is above self and position holds a piece
        vertical_dupe.reject! do |move|
          if piece.color != self.color
            move[1] < piece.position[1]  #eliminate all y greater than current position y
          else
            move[1] <= piece.position[1]
          end
        end
      end
    end

    horizontal_dupe = horizontal_moves.dup

    horizontal_moves.each do |move|
      piece = board[move[0]][move[1]]
      if move[0] > self.position[0] && piece != nil # if position is to the right
        horizontal_dupe.reject! do |move|
          if piece.color != self.color
            move[0] > piece.position[0]
          else
            move[0] >= piece.position[0]
          end
        end  #eliminate all y greater than current position y
      end
      if move[0] < self.position[0]  && piece != nil #if position is above self and position holds a piece
        horizontal_dupe.reject! do |move|
          if piece.color != self.color
            move[0] < piece.position[0]
          else
            move[0] <= piece.position[0]
          end
        end  #if piece is above self, reject all y less than current y
      end
    end

    horizontal_dupe + vertical_dupe + diagonal_dupe
  end


end

module SteppingPiece

  def moves
    knight_moves = []
    # debugger
    position = self.position
    x = position[0]
    y = position[1]
    knight_moves << [x + 2, y - 1]
    knight_moves << [x + 2, y + 1]
    knight_moves << [x - 2, y - 1]
    knight_moves << [x - 2, y + 1]
    knight_moves << [x + 1, y - 2]
    knight_moves << [x - 1, y - 2]
    knight_moves << [x - 1, y + 2]
    knight_moves << [x + 1, y + 2]

    # knight_dupe = knight_moves.dup
    # debugger

    knight_moves.select! { |move| move[0] >= 0 && move[1] >= 0 && move[1] <= 7 && move[0] <= 7 }

    knight_moves.reject! { |move|
      # piece = board[move[0]][move[1]]
      board.board[move[0]][move[1]] != nil && board.board[move[0]][move[1]].color == self.color }

    knight_moves
  end

end


class Piece
  attr_accessor :position, :name
  attr_reader :board, :color

  def initialize(name, position, color, board)
    @name = name
    @position = position
    @color = color
    @board = board
  end

  def move_into_check?(end_pos)
    duped_board = Board.new
    self.board.board.each_with_index do |row, row_idx|
        row.each_with_index do |col, col_idx|
            duped_board.board[row_idx][col_idx] = self.board.board[row_idx][col_idx].dup unless self.board.board[row_idx][col_idx] == nil
        end
    end
    debugger
    duped_board.move_piece(self.position, end_pos)
    duped_board.in_check?(self.color)
  end

end

#     b.board[4][4] = Knight.new('k', [4,4], 'black',b)

class King < Piece
  def initialize(name, position, color, board)
    super(name, position, color, board)
  end

  def moves
    position = self.position
    x = position[0]
    y = position[1]
    king_moves = []
    king_moves << [x + 1, y + 1] #up right
    king_moves << [x - 1, y - 1] #down left
    king_moves << [x + 1, y - 1] #down right
    king_moves << [x - 1, y + 1] #up left

    king_moves << [x + 1, y] #right
    king_moves << [x - 1, y] #left
    king_moves << [x, y + 1] #up
    king_moves << [x, y - 1] #down

    king_moves.select! { |move| move[0] >= 0 && move[1] >= 0 && move[1] <= 7 && move[0] <= 7 }
    king_moves.reject! { |move| board.board[move[0]][move[1]] != nil && board.board[move[0]][move[1]].color == self.color }
    king_moves
  end

end

class Pawn < Piece

  def initialize(name, position, color, board)
    super(name, position, color, board)
  end

  def moves
    position = self.position
    x = position[0]
    y = position[1]
    pawn_moves = []

    pawn_moves << [x + 1, y] #right
    pawn_moves << [x - 1, y] #left
    pawn_moves << [x, y + 1] #up
    pawn_moves << [x, y - 1] #down


    pawn_moves.reject! { |move| board.board[move[0]][move[1]] != nil && board.board[move[0]][move[1]].color == self.color }

    #adding eating logic
    if self.color == "black"
      if board.board[x+1][y+1] != nil
        pawn_moves << [x + 1, y + 1] if board.board[x+1][y+1].color == "white"
      end
      if board.board[x+1][y-1] != nil
        pawn_moves << [x + 1, y - 1] if board.board[x+1][y-1].color == "white"
      end
    end
    if self.color == "white"
      if board.board[x-1][y+1] != nil
        pawn_moves << [x - 1, y + 1] if board.board[x-1][y+1].color == "black"
      end
      if board.board[x-1][y-1] != nil
        pawn_moves << [x - 1, y - 1] if board.board[x-1][y-1].color == "black"
      end
    end

    pawn_moves.select! { |move| move[0] >= 0 && move[1] >= 0 && move[1] <= 7 && move[0] <= 7 }
    pawn_moves

  end

end

class Rook < Piece
  attr_reader :directions
  include SlidingPiece
  def initialize(name, position, color, board)
    super(name, position, color, board)
    @directions = [:horizontal, :vertical]
  end

end

class Bishop < Piece
  attr_reader :directions
  include SlidingPiece
  def initialize(name, position, color, board)
    super(name, position, color, board)
    @directions = [:diagonal]
  end



end
#
class Knight < Piece
  include SteppingPiece
  def initialize(name, position, color, board)
    super(name, position, color, board)
  end

end



class Queen < Piece
  attr_reader :directions
  include SlidingPiece
  def initialize(name, position, color, board)
    super(name, position, color, board)
    @directions = [:horizontal, :vertical, :diagonal]
  end

end

class NullPiece < Piece
  # include Singleton
  def initialize(name, position, color, board)
    super(name, position, color, board)
  end

end

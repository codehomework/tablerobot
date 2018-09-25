require_relative 'robot_engine'
require_relative './../errors'

# A simple implementation of a Robot Engine is a 2-dimensional
# array in ruby, taking the form [x][y].
#
# The homework spec describes positions in Quadrant I; however
# arrays in Ruby described traditionally as [x][y] are Quadrant
# IV. Quandrant I is a mirror image of Quadrant IV over the x-axis.
# The storage and retrieval of x,y positions are not affected
# by quadrants -- but moving and rotation are. Therefore, to
# accomodate the mirror image over the x-axis, incoming coordinates
# for moving and rotation are translated from QI to QIV. This
# keeps our logic simple -- x and y are always x and y -- while
# still separating the concerns of who should know about different
# coordinate systems.
#
class TwoDimensionalArrayRobotEngine
  include RobotEngine
  attr_accessor :data
  public
    def initialize(board_size_x, board_size_y)
      @board_size_x = board_size_x
      @board_size_y = board_size_y
      @data = empty_board
    end

    def place(x:, y:, facing:)
      raise WouldMoveRobotOffBoardError if x >= @board_size_x || x < 0 || y >= @board_size_y || y < 0
      @data = empty_board
      @data[x][y] = facing
    end

    def move
      x, y, facing = find_robot
      moved_x, moved_y = increment_QI_direction_to_QIV_coordinates(x, y, facing)
      place(x: moved_x, y: moved_y, facing: facing)
    end

    def left
      rotate :left
    end

    def right
      rotate :right
    end

    def report
      x, y, facing = find_robot
      return "#{x},#{y},#{facing}"
    end
  private
    def empty_board
      Array.new(@board_size_x){Array.new(@board_size_y)}
    end

    def rotate(to_the)
      x, y, facing = find_robot
      rotate_cardinally = {
        NORTH: {
          left: :WEST,
          right: :EAST 
        },
        SOUTH: {
          left: :EAST,
          right: :WEST
        },
        EAST: {
          left: :NORTH,
          right: :SOUTH
        },
        WEST: {
          left: :SOUTH,
          right: :NORTH
        }
      }
      place(x: x, y: y, facing: rotate_cardinally[facing][to_the])
    end

    def find_robot
      @data.each_with_index do |row_data, row_index|
        row_data.each_with_index do |cell_data, cell_index|
          return [row_index, cell_index, cell_data] unless cell_data.nil?
        end
      end
      raise RobotMovedWithoutBeingPlacedFirst
    end

    def increment_QI_direction_to_QIV_coordinates(x, y, facing)
      case facing
      when :NORTH
        [x, y + 1]
      when :SOUTH
        [x, y - 1]
      when :EAST
        [x + 1, y]
      when :WEST
        [x - 1, y]
      end      
    end
end

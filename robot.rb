require_relative './robot_engines/two_dimensional_array_robot_engine'
require_relative 'errors'

# Point-of-entry for communicating with the toy robot. Simply
# make an instance and call #dispatch("COMMAND") to do stuff.
#
# Valid commands are:
#   - PLACE X,Y,Z
#   - MOVE
#   - LEFT
#   - RIGHT
#   - REPORT
#
# For example:
#   r = Robot.new
#   r.dispatch("PLACE 1,2,NORTH")
#
# Invalid commands will be ignored, and an error message will be
# printed to the TTY.
#
# The robot defaults to a 5x5 grid, but any grid size can be
# initialized in the constructor.
#
# The robot engine is a dependency injected data store, which can
# provide different implementations of positioning and moving
# a robot at runtime. Currently, the only one provided is a 
# two-dimensional array robot engine, which is the default.
#
# If you want to catch invalid conditions yourself (e.g., doing this
# would move the robot off the table), subclass Robot and re-implement
# your own #dispatch.
class Robot
  attr_accessor :board_size, :engine

  public
  def initialize(board_size: [5,5], engine_klass: TwoDimensionalArrayRobotEngine)
    @board_size = board_size
    @engine = engine_klass.new(*board_size)
  end

  def dispatch(cmd)
    # Step 1: Parse the string into a command hash object
    begin
      move_fn = parse(cmd)
    rescue InvalidRobotCommandError
      puts "I'm sorry, I can't do that Hal..."
      return
    end
    # Step 2: Call the robot engine with that command hash
    begin
      return @engine.send *[move_fn[:method], move_fn[:arguments]].compact
    rescue WouldMoveRobotOffBoardError
      puts "That would have moved me off the board! Are you trying to kill me!?"
      return
    rescue RobotMovedWithoutBeingPlacedFirst
      puts "I can't go somewhere until you tell me where I am. (Hint: PLACE me first)"
    end
  end

  private
    # Uses regex to convert string commands from the user, like PLACE 1,2,NORTH
    # into a hash of { method: ..., arguments: }
    def parse(cmd)
      re_result = /^((?<place>PLACE (?<place_x>\d+),(?<place_y>\d+),(?<place_facing>NORTH|SOUTH|EAST|WEST))|(?<move>MOVE)|(?<left>LEFT)|(?<right>RIGHT)|(?<report>REPORT))$/.match(cmd)
      raise InvalidRobotCommandError if re_result.nil?
      ( re_result[:place] && { method: :place, arguments: {x: re_result[:place_x].to_i, y: re_result[:place_y].to_i, facing: re_result[:place_facing].to_sym} }  ) \
      || ( re_result[:move] && { method: :move } ) \
      || ( re_result[:left] && { method: :left } ) \
      || ( re_result[:right] && { method: :right } ) \
      || ( re_result[:report] && { method: :report } )
    end
end

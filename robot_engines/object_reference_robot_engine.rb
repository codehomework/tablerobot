require_relative 'robot_engine'

# I didn't have time, but an alternative implementation of
# a Robot Engine might use object references. Imagine a system
# where each cell on the 5x5 table had 4 pointers going north,
# south, east, and west, and the robot simply had a pointer to
# its current cell. It would be a cleaner, less array-janky
# implemtnation of a Robot Engine, but alas, I didn't have time
# to implement this idea. I'm including it here as an example of
# the swappable nature of dependency injected Robot Engines.
class ObjectReferenceRobotEngine
  include RobotEngine
  def initialize(board_size_x, board_size_y)
  end
end

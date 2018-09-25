# A robot engine implements the logic of placing, moving,
# rotating, and introspecting the Robot. Simply include
# this module in your class, and you have a duck-type ready
# robot engine.
module RobotEngine
  attr_accessor :board_size_x, :board_size_y
  def initialize(board_size_x, board_size_y)
    raise NotImplementedError.new("RobotEngine implementers must override #initialize(board_size_x, board_size_y)")
  end
  def place(x:, y:, facing:)
    raise NotImplementedError.new("RobotEngine implementers must override #place(x:, y:, facing:)")
  end
  def move
    raise NotImplementedError.new("RobotEngine implementers must override #move")
  end
  def left
    raise NotImplementedError.new("RobotEngine implementers must override #left")
  end
  def right
    raise NotImplementedError.new("RobotEngine implementers must override #right")
  end
  def report
    raise NotImplementedError.new("RobotEngine implementers must override #report")
  end
end

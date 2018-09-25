# When you attempt to move the robot, but it hasn't
# been PLACE'd yet
class RobotMovedWithoutBeingPlacedFirst < StandardError
end

# The command string isn't valid or parseable
class InvalidRobotCommandError < StandardError
end

# When you attempt to move the Robot off the table
class WouldMoveRobotOffBoardError < StandardError
end

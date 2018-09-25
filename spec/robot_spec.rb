require_relative './../robot'
require_relative './../robot_engines/two_dimensional_array_robot_engine'
require_relative './../robot_engines/object_reference_robot_engine'
require_relative './../errors'

RSpec::Expectations.configuration.on_potential_false_positives = :nothing

describe Robot do
  describe "#initialize" do
    it "creates a robot engine by default" do
      robot = Robot.new
      expect(robot.engine).to_not be_nil
    end
    it "defaults to TwoDimensionalArrayRobotEngine" do
      robot = Robot.new
      expect(robot.engine).to be_an_instance_of(TwoDimensionalArrayRobotEngine)
    end
    it "accepts an optional robot engine" do
      robot = Robot.new(engine_klass: ObjectReferenceRobotEngine)
      expect(robot.engine).to be_an_instance_of(ObjectReferenceRobotEngine)
    end
  end
  describe "#parse" do
    before do
      @robot = Robot.new(board_size: [5,5])
      @action = nil
    end
    describe "PLACE" do
      describe "works with" do
        it "NORTH" do
          expect { @action = @robot.send :parse, 'PLACE 0,0,NORTH' }.not_to raise_error(InvalidRobotCommandError)
          expect(@action).to be == { method: :place, arguments: {x: 0, y: 0, facing: :NORTH } }
        end
        it "SOUTH" do
          expect { @action = @robot.send :parse, 'PLACE 0,0,SOUTH' }.not_to raise_error(InvalidRobotCommandError)
          expect(@action).to be == { method: :place, arguments: {x: 0, y: 0, facing: :SOUTH } }
        end
        it "EAST" do
          expect { @action = @robot.send :parse, 'PLACE 0,0,EAST' }.not_to raise_error(InvalidRobotCommandError)
          expect(@action).to be == { method: :place, arguments: {x: 0, y: 0, facing: :EAST } }
        end
        it "WEST" do
          expect { @action = @robot.send :parse, 'PLACE 0,0,WEST' }.not_to raise_error(InvalidRobotCommandError)
          expect(@action).to be == { method: :place, arguments: {x: 0, y: 0, facing: :WEST } }
        end
        it "upper-limit X" do
          expect { @action = @robot.send :parse, 'PLACE 4,0,NORTH' }.not_to raise_error(InvalidRobotCommandError)
          expect(@action).to be == { method: :place, arguments: {x: 4, y: 0, facing: :NORTH } }
        end
        it "upper-limit Y" do
          expect { @action = @robot.send :parse, 'PLACE 0,4,NORTH' }.not_to raise_error(InvalidRobotCommandError)
          expect(@action).to be == { method: :place, arguments: {x: 0, y: 4, facing: :NORTH } }
        end
        it "upper-limit X and Y" do
          expect { @action = @robot.send :parse, 'PLACE 4,4,NORTH' }.not_to raise_error(InvalidRobotCommandError)
          expect(@action).to be == { method: :place, arguments: {x: 4, y: 4, facing: :NORTH } }
        end
      end
      describe "doesn't work with" do
        it "spaces" do
          expect { @robot.send :parse, 'PLACE 0, 0, NORTH' }.to raise_error(InvalidRobotCommandError)
        end
        it "trailing comma" do
          expect { @robot.send :parse, 'PLACE 0,0,NORTH,' }.to raise_error(InvalidRobotCommandError)
        end
        it "integer facing" do
          expect { @robot.send :parse, 'PLACE 1,1,1' }.to raise_error(InvalidRobotCommandError)
        end
        it "no facing" do
          expect { @robot.send :parse, 'PLACE 1,1' }.to raise_error(InvalidRobotCommandError)
        end
        it "no Y" do
          expect { @robot.send :parse, 'PLACE 1,NORTH' }.to raise_error(InvalidRobotCommandError)
        end
        it "bonk facing" do
          expect { @robot.send :parse, 'PLACE 4,4,NORTHWEST' }.to raise_error(InvalidRobotCommandError)
        end
        it "string X and Y" do
          expect { @robot.send :parse, 'PLACE Manny,Moe,Jack' }.to raise_error(InvalidRobotCommandError)
        end
        it "giant string with commas" do
          expect { @robot.send :parse, 'PLACE It was the best of times, it was the worst of times' }.to raise_error(InvalidRobotCommandError)
        end
      end
    end
    describe "MOVE" do
      it "works on its own" do
        expect { @action = @robot.send :parse, 'MOVE' }.not_to raise_error(InvalidRobotCommandError)
        expect(@action).to be == { method: :move }
      end
      it "doesn't work with suffix" do
        expect { @robot.send :parse, 'MOVE 1,2' }.to raise_error(InvalidRobotCommandError)
      end
    end
    describe "LEFT" do
      it "works on its own" do
        expect { @action = @robot.send :parse, 'LEFT' }.not_to raise_error(InvalidRobotCommandError)
        expect(@action).to be == { method: :left }
      end
      it "doesn't work with suffix" do
        expect { @robot.send :parse, 'LEFT NORTH' }.to raise_error(InvalidRobotCommandError)
      end
    end
    describe "RIGHT" do
      it "works on its own" do
        expect { @action = @robot.send :parse, 'RIGHT' }.not_to raise_error(InvalidRobotCommandError)
        expect(@action).to be == { method: :right }
      end
      it "doesn't work with suffix" do
        expect { @robot.send :parse, 'RIGHT 1' }.to raise_error(InvalidRobotCommandError)
      end
    end
    describe "REPORT" do
      it "works on its own" do
        expect { @action = @robot.send :parse, 'REPORT' }.not_to raise_error(InvalidRobotCommandError)
        expect(@action).to be == { method: :report }
      end
      it "doesn't work with suffix" do
        expect { @robot.send :parse, 'REPORT 1,2,NORTH' }.to raise_error(InvalidRobotCommandError)
      end
    end
    describe "invalid verbs" do
      it "do not work" do
        expect { @robot.send :parse, 'AMAZON original series' }.to raise_error(InvalidRobotCommandError)
      end
    end
  end
end

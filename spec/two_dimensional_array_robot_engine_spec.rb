require_relative './../robot_engines/two_dimensional_array_robot_engine'
require_relative './../errors'

describe TwoDimensionalArrayRobotEngine do
  before do
    @tdare = TwoDimensionalArrayRobotEngine.new(5,5)
  end
  describe "#place" do
    describe "stores data exactly as provided" do
      it "at 0,0" do 
        @tdare.place(x: 0, y: 0, facing: :NORTH)
        expect(@tdare.data[0][0]).to be :NORTH
      end
      it "at 4,1" do
        @tdare.place(x: 4, y: 1, facing: :SOUTH)
        expect(@tdare.data[4][1]).to be :SOUTH
      end
    end
    it "rejects out of range data" do
      expect { @tdare.place(x: 5, y: 1, facing: :EAST) }.to raise_error(WouldMoveRobotOffBoardError)
      expect { @tdare.place(x: 2, y: 5, facing: :WEST) }.to raise_error(WouldMoveRobotOffBoardError)
    end
  end
  describe "#move" do
    it "does nothing if the robot hasn't been placed first" do
      expect{ @tdare.move }.to raise_error(RobotMovedWithoutBeingPlacedFirst)
    end
    describe "NORTH" do
      it "moves if there's space" do
        @tdare.place(x: 0, y: 0, facing: :NORTH)
        expect(@tdare.data[0][0]).to be :NORTH
        @tdare.move
        expect(@tdare.data[0][1]).to be :NORTH
      end
      it "doesn't if there's not" do
        @tdare.place(x: 2, y: 4, facing: :NORTH)
        expect(@tdare.data[2][4]).to be :NORTH
        expect{ @tdare.move }.to raise_error(WouldMoveRobotOffBoardError)
        expect(@tdare.data[2][4]).to be :NORTH
      end
    end
    describe "SOUTH" do
      it "moves if there's space" do
        @tdare.place(x: 1, y: 2, facing: :SOUTH)
        expect(@tdare.data[1][2]).to be :SOUTH
        @tdare.move
        expect(@tdare.data[1][1]).to be :SOUTH
      end
      it "doesn't if there's not" do
        @tdare.place(x: 2, y: 0, facing: :SOUTH)
        expect(@tdare.data[2][0]).to be :SOUTH
        expect{ @tdare.move }.to raise_error(WouldMoveRobotOffBoardError)
        expect(@tdare.data[2][0]).to be :SOUTH
      end
    end
    describe "EAST" do
      it "moves if there's space" do
        @tdare.place(x: 3, y: 3, facing: :EAST)
        expect(@tdare.data[3][3]).to be :EAST
        @tdare.move
        expect(@tdare.data[4][3]).to be :EAST
      end
      it "doesn't if there's not" do
        @tdare.place(x: 4, y: 0, facing: :EAST)
        expect(@tdare.data[4][0]).to be :EAST
        expect{ @tdare.move }.to raise_error(WouldMoveRobotOffBoardError)
        expect(@tdare.data[4][0]).to be :EAST
      end
    end
    describe "WEST" do
      it "moves if there's space" do
        @tdare.place(x: 3, y: 1, facing: :WEST)
        expect(@tdare.data[3][1]).to be :WEST
        @tdare.move
        expect(@tdare.data[2][1]).to be :WEST
      end
      it "doesn't if there's not" do
        @tdare.place(x: 0, y: 2, facing: :WEST)
        expect(@tdare.data[0][2]).to be :WEST
        expect{ @tdare.move }.to raise_error(WouldMoveRobotOffBoardError)
        expect(@tdare.data[0][2]).to be :WEST
      end
    end
  end
  describe "#left" do
    it "does nothing if the robot hasn't been placed first" do
      expect{ @tdare.left }.to raise_error(RobotMovedWithoutBeingPlacedFirst)
    end
    it "moves north -> west" do
      @tdare.place(x: 1, y: 1, facing: :NORTH)
      expect(@tdare.data[1][1]).to be :NORTH
      @tdare.left
      expect(@tdare.data[1][1]).to be :WEST
    end
    it "moves west -> south" do
      @tdare.place(x: 1, y: 1, facing: :WEST)
      expect(@tdare.data[1][1]).to be :WEST
      @tdare.left
      expect(@tdare.data[1][1]).to be :SOUTH
    end
    it "moves south -> east" do
      @tdare.place(x: 1, y: 1, facing: :SOUTH)
      expect(@tdare.data[1][1]).to be :SOUTH
      @tdare.left
      expect(@tdare.data[1][1]).to be :EAST
    end
    it "moves east -> north" do
      @tdare.place(x: 1, y: 1, facing: :EAST)
      expect(@tdare.data[1][1]).to be :EAST
      @tdare.left
      expect(@tdare.data[1][1]).to be :NORTH
    end
  end
  describe "#right" do
    it "does nothing if the robot hasn't been placed first" do
      expect{ @tdare.right }.to raise_error(RobotMovedWithoutBeingPlacedFirst)
    end
    it "moves north->east" do
      @tdare.place(x: 1, y: 1, facing: :NORTH)
      expect(@tdare.data[1][1]).to be :NORTH
      @tdare.right
      expect(@tdare.data[1][1]).to be :EAST
    end
    it "moves east->south" do
      @tdare.place(x: 1, y: 1, facing: :EAST)
      expect(@tdare.data[1][1]).to be :EAST
      @tdare.right
      expect(@tdare.data[1][1]).to be :SOUTH
    end
    it "moves south->west" do
      @tdare.place(x: 1, y: 1, facing: :SOUTH)
      expect(@tdare.data[1][1]).to be :SOUTH
      @tdare.right
      expect(@tdare.data[1][1]).to be :WEST
    end
    it "moves west->north" do
      @tdare.place(x: 1, y: 1, facing: :WEST)
      expect(@tdare.data[1][1]).to be :WEST
      @tdare.right
      expect(@tdare.data[1][1]).to be :NORTH
    end
  end
  describe "#report" do
    it "returns nothing if the robot hasn't been placed first" do
      expect{ @tdare.report }.to raise_error(RobotMovedWithoutBeingPlacedFirst)
    end
    it "returns the current location" do
      @tdare.place(x: 1, y: 4, facing: :SOUTH)
      expect(@tdare.report).to eq "1,4,SOUTH"
    end
  end
end

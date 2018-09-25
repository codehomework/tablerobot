require_relative './../robot'

describe "The assignment's integration tests" do
  before do
    @robot = Robot.new
  end
  it "Example A" do
    @robot.dispatch("PLACE 0,0,NORTH")
    @robot.dispatch("MOVE")
    expect(@robot.dispatch("REPORT")).to eq "0,1,NORTH"
  end
  it "Example B" do
    @robot.dispatch("PLACE 0,0,NORTH")
    @robot.dispatch("LEFT")
    expect(@robot.dispatch("REPORT")).to eq "0,0,WEST"
  end
  it "Example C" do
    @robot.dispatch("PLACE 1,2,EAST")
    @robot.dispatch("REPORT")
    @robot.dispatch("MOVE")
    @robot.dispatch("REPORT")
    @robot.dispatch("MOVE")
    @robot.dispatch("LEFT")
    @robot.dispatch("MOVE")
    expect(@robot.dispatch("REPORT")).to eq "3,3,NORTH"
  end
end

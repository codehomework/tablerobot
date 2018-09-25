# TableRobot: a Ruby tabletop robot in 3 hours
Hello, and thank you for reviewing my code homework for the engineering team. I appreciate the opportunity to audition with you guys.

All work is my own. No robots were harmed in the making of this code. 😇

## 🎓 The Assignment
*Note: This assignment was provided by the company. I am including it here verbatim.*

This take-home exercise consists of has been modified to be 1 question. You should time box the exercise to take no more than 3 hours total. During the interview, you should be able to demo your application, run your tests and explain your choices. If you are unable to demo the application or complete the assignment, you should be ready to explain what might have gone wrong and what the problems were. When you feel the assignment is complete, send us a link to your code on GitHub, or you may zip the code and send via e-mail. Please feel free to reach out if you have any questions!

### Specification
In Ruby, complete the following:

The application is a simulation of a toy robot moving on a square tabletop, of dimensions 5 units x 5 units. There are no other obstructions on the table surface. The robot is free to roam around the surface of the table, but must be prevented from falling to destruction. Any movement that would result in the robot falling from the table must be prevented, however further valid movement commands must still be allowed.

Create an application that can read in commands of the following form:

```
PLACE X,Y,F
MOVE
LEFT
RIGHT
REPORT
```

- `PLACE` will put the toy robot on the table in position `X,Y` and facing `NORTH`, `SOUTH`, `EAST` or `WEST`
- The origin `(0,0)` can be considered to be the `SOUTH WEST` most corner
- The first valid command to the robot is a `PLACE` command, after that, any sequence of commands may be issued, in any order, including another `PLACE` command. The application should discard all commands in the sequence until a valid `PLACE` command has been executed.
- `MOVE` will move the toy robot one unit forward in the direction it is currently facing
- `LEFT` and `RIGHT` will rotate the robot 90 degrees in the specified direction without changing the position of the robot
- `REPORT` will announce the `X,Y` and `F` of the robot. This can be in any form, but standard output is sufficient.
- A robot that is not on the table can choose the ignore the `MOVE`, `LEFT`, `RIGHT` and `REPORT` commands

Provide test data to exercise the application. The toy robot must not fall off the table during movement. This also includes the initial placement of the toy robot. Any move that would cause the robot to fall must be ignored.

### Example Input and Output
#### Example A
```
PLACE 0,0,NORTH
MOVE
REPORT
```
-> Expected output: `0,1,NORTH`

#### Example B
```
PLACE 0,0,NORTH
LEFT
REPORT
```
-> Expected output: `0,0,WEST`

#### Example C
```
PLACE 1,2,EAST
MOVE
MOVE
LEFT
MOVE
REPORT
```
-> Expected output: `3,3,NORTH`

### Deliverables
- Please provide your source code, and any test code/data you use in developing your solution.
- It is not required to provide any graphical output showing the movement of the toy robot. It is also not required for the application to read from stdin.
- Provide instructions on how to use the program in the interactive console, calling the classes and methods directly. Please also provide instructions for running the tests.

## 🏃 My Solution
1. If you use [vagrant](./Vagrantfile): `vagrant up`, `vagrant ssh`, `cd ~/tablerobot`
2. If you don't use vagrant, just `cd` to this folder on a machine with Ruby installed and run `bundle` ([installs RSpec](./Gemfile))
3. To run RSpec suite: `rspec -f d`
4. To run interactively (`irb`):
```
require_relative 'robot'
robot = Robot.new
robot.dispatch("PLACE 0,0,NORTH")
```

## 🤔 Design
Reading the spec, I saw the Robot assignment as consisting of 2 separate parts:
1. The [🤖`Robot`](./robot.rb), <i>a human-language interface to the outside world</i> that
- accepts commands from the outside world, like `PLACE 1,2,NORTH`
- parses those commands, and delegates them to an implementer

2. A [⚙`Robot Engine`](./robot_engines/robot_engine.rb), <i>an abstract interface to a finate-state machine</i> whose implementers:
- can place
- can move
- can rotate right or left
- can report and introspect

Implementing a concrete [⚙`Robot Engine`](./robot_engines/robot_engine.rb) could take infinite forms...
- [a 2-dimensional array](./robot_engines/two_dimensional_array_robot_engine.rb)
- an RDBMS like MySQL
- a NoSQL, like Redis
- [PORO references](./robot_engines/object_reference_robot_engine.rb)
- a JSON or XML API

The <b>most important part is that all ⚙`Robot Engine`'s should use a [common interface](./robot_engines/robot_engine.rb)</b>, so swapping out a different finite-state machine doesn't require changes to the [🤖`Robot`](./robot.rb) itself. Going from a 2-dimensional array FSM, to a JSON API FSM, should not require changes to the [🤖`Robot`](./robot.rb).

## 🤓 Code
I set out to implement exactly that.

- Given the timebox for this assignment, I chose to implement the ⚙`Robot Engine` as a [a 2-dimensional array](./robot_engines/two_dimensional_array_robot_engine.rb). (I also experimented with a [PORO references](./robot_engines/object_reference_robot_engine.rb) ⚙`Robot Engine`)
- I used a [dependancy injection](https://en.wikipedia.org/wiki/Dependency_injection) design pattern to provide the 🤖`Robot` [with any ⚙`Robot Engine` at runtime](./robot.rb#L38)
- I parse commands like `PLACE 0,0,NORTH` and `MOVE` using [regex](./robot.rb#L61-L71), and morph them into a metaprogammatically dispatchable message
- I pass the command to ⚙`Robot Engine` using [metaprogramming](./robot.rb#L51)
- If the user types in junk, I throw/catch a `InvalidRobotCommandError`
- If the user tries to move the robot off the board, I throw/catch a `WouldMoveRobotOffBoardError`
- If the user tries to do anything before `PLACE`'ing the 🤖`Robot`, I throw/catch a `RobotMovedWithoutBeingPlacedFirst`
- The actual [2-dimensional array ⚙`Robot Engine`](./robot_engines/two_dimensional_array_robot_engine.rb) implementation is pretty simple, except for some simple [`Quadrant I <--> Quadrant IV`](./robot_engines/two_dimensional_array_robot_engine.rb#L57-L100) transformations, since the spec says `0,0` is the southwest corner.

## 🎯 Testing
I decided to test 3 things:

1. [The Assignment](./spec/the_assignment_integration_spec.rb), as an <i>integration test</i>.
Why? If this doesn't work, I fail the assignment. And, integration tests are great ROI.

2. The 🤖`Robot`'s natural-language [regex parsing](./spec/robot_spec.rb), as a <i>unit test</i>.
Why? If this doesn't work, the bugs could be subtle and timely to debug.

3. The [2-dimensional array ⚙`Robot Engine`](./spec/two_dimensional_array_robot_engine_spec.rb), as a <i>unit test</i>.
Why? I wanted to make sure I got the Quadrant conversion correct.

## 🥇 Conclusion
I am happy with my result. I aimed to demonstrate that I can take architectural concepts, like separations of concerns, interfaces, design patterns, and Ruby chops, and build a readable Robot. I look forward to discussing my submission with your team.

Thanks for reading!

![Alt Text](https://media.giphy.com/media/3ohs7M2llDej8uvp3W/giphy.gif)

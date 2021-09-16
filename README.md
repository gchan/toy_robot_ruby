# Toy Robot

Toy Robot is a common coding exercise employers use to evaluate potential
candidates. This repository contains my Ruby solution to this exercise.

## Setup

* [Install Ruby](https://www.ruby-lang.org/en/documentation/installation/) 2.7.4
* Install Bundler - `gem install bundler`
* Install RubyGem gem/library dependencies with Bundler - `bundle`

## Running the code

* `rspec` - run all the tests
* `./bin/simulate start` - starts the simulation and accept commands through standard input
* `./bin/simulate file` - starts the simulation and runs the commands from a sample command file './sample_commands/sample_command_file.txt'
* `./bin/simulate file ./my_command_file.txt` - starts the simulation and runs the commands from the specified filename
* `./bin/console` - starts a Ruby shell (console) with the code dependencies pre-loaded.

## Specification

Retrieved from https://joneaves.wordpress.com/2014/07/21/toy-robot-coding-test/

### Description

* The application is a simulation of a toy robot moving on a square tabletop, of dimensions 5 units x 5 units.
* There are no other obstructions on the table surface.
* The robot is free to roam around the surface of the table, but must be prevented from falling to destruction. Any movement that would result in the robot falling from the table must be prevented, however further valid movement commands must still be allowed.

* Create an application that can read in commands of the following form –

```
PLACE X,Y,F
MOVE
LEFT
RIGHT
REPORT
```

* PLACE will put the toy robot on the table in position X,Y and facing NORTH, SOUTH, EAST or WEST.
* The origin (0,0) can be considered to be the SOUTH WEST most corner.
* The first valid command to the robot is a PLACE command, after that, any sequence of commands may be issued, in any order, including another PLACE command. The application should discard all commands in the sequence until a valid PLACE command has been executed.
* MOVE will move the toy robot one unit forward in the direction it is currently facing.
* LEFT and RIGHT will rotate the robot 90 degrees in the specified direction without changing the position of the robot.
* REPORT will announce the X,Y and F of the robot. This can be in any form, but standard output is sufficient.

* A robot that is not on the table can choose the ignore the MOVE, LEFT, RIGHT and REPORT commands.
* Input can be from a file, or from standard input, as the developer chooses.
* Provide test data to exercise the application.

### Constraints

The toy robot must not fall off the table during movement. This also includes the initial placement of the toy robot.

Any move that would cause the robot to fall must be ignored.

Example Input and Output:

a)
```
PLACE 0,0,NORTH
MOVE
REPORT
````
Output: 0,1,NORTH

b)
```
PLACE 0,0,NORTH
LEFT
REPORT
```
Output: 0,0,WEST

c)
```
PLACE 1,2,EAST
MOVE
MOVE
LEFT
MOVE
REPORT
```
Output: 3,3,NORTH

## License

MIT

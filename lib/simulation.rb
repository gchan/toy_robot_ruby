# frozen_string_literal: true

require_relative 'robot'

class Simulation
  TABLE_WIDTH = 5
  TABLE_HEIGHT = 5

  InvalidCommandError = Class.new(StandardError)

  def initialize
    @robot = Robot.new
  end

  def process_commands(commands)
    commands.split("\n").each do |command|
      process_command(command)
    end
  end

  def process_command(command)
    case command
    when /PLACE/
      place_robot(command)
    when 'MOVE'
      move_robot
    when 'LEFT'
      robot.turn_left
    when 'RIGHT'
      robot.turn_right
    when 'REPORT'
      report
    else
      raise InvalidCommandError, "unexpected command #{command}"
    end
  end

  private

  attr_reader :robot

  def place_robot(command)
    _, x, y, facing = command.scan(/[^\s,]+/)

    x = Integer(x)
    y = Integer(y)

    if x.negative? || y.negative? || x >= TABLE_WIDTH || y >= TABLE_HEIGHT
      raise InvalidCommandError, 'unable to place robot off the table with '\
        "command: #{command}"
    end

    robot.place(
      x_position: x,
      y_position: y,
      facing: facing.downcase
    )
  end

  def move_robot
    return unless robot.placed?

    next_position = robot.next_position
    next_x = next_position[:x_position]
    next_y = next_position[:y_position]

    return if next_x.negative? || next_y.negative? ||
              next_x >= TABLE_WIDTH || next_y >= TABLE_HEIGHT

    robot.move_forward
  end

  def report
    return unless robot.placed?

    $stdout.puts "#{robot.x_position},#{robot.y_position}," \
      "#{robot.facing.upcase}"
  end
end

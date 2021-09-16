# frozen_string_literal: true

class Robot
  FACING_DIRECTIONS = %w[north east south west].freeze

  attr_reader :x_position, :y_position, :facing

  def place(x_position:, y_position:, facing:)
    unless x_position.is_a?(Integer)
      raise ArgumentError, 'x_position is not an Integer'
    end

    unless y_position.is_a?(Integer)
      raise ArgumentError, 'y_position is not an Integer'
    end

    unless FACING_DIRECTIONS.include?(facing)
      raise ArgumentError, 'facing is not one of: ' \
        "#{FACING_DIRECTIONS.join(', ')}"
    end

    @x_position = x_position
    @y_position = y_position
    @facing = facing
  end

  def placed?
    x_position && y_position && facing
  end

  def next_position
    next_x = x_position
    next_y = y_position

    case facing
    when 'north'
      next_y += 1
    when 'east'
      next_x += 1
    when 'south'
      next_y -= 1
    when 'west'
      next_x -= 1
    end

    {
      x_position: next_x,
      y_position: next_y
    }
  end

  def move_forward
    return unless placed?

    move_to = next_position

    @x_position = move_to[:x_position]
    @y_position = move_to[:y_position]
  end

  def turn_left
    return unless placed?

    direction_index = FACING_DIRECTIONS.index(facing) - 1
    direction_index %= 4
    @facing = FACING_DIRECTIONS[direction_index]
  end

  def turn_right
    return unless placed?

    direction_index = FACING_DIRECTIONS.index(facing) + 1
    direction_index %= 4
    @facing = FACING_DIRECTIONS[direction_index]
  end
end

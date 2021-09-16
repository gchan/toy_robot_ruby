# frozen_string_literal: true

require 'spec_helper'
require 'simulation'

RSpec.describe Simulation do
  subject(:simulation) { described_class.new }
  let(:robot) { Robot.new }

  before do
    allow(Robot).to receive(:new).and_return(robot)
  end

  describe '#process_command' do
    it 'places on PLACE' do
      simulation.process_command('PLACE 1, 2, WEST')

      expect(robot).to have_attributes(
        x_position: 1,
        y_position: 2,
        facing: 'west'
      )
    end

    it 'moves the robot forward on MOVE' do
      simulation.process_command('PLACE 1, 2, WEST')
      simulation.process_command('MOVE')

      expect(robot).to have_attributes(
        x_position: 0,
        y_position: 2,
        facing: 'west'
      )
    end

    it 'turns the robot left on LEFT' do
      expect(robot).to receive(:turn_left).and_call_original
      simulation.process_command('PLACE 1, 2, WEST')
      simulation.process_command('LEFT')

      expect(robot).to have_attributes(
        facing: 'south'
      )
    end

    it 'turns the robot right on RIGHT' do
      expect(robot).to receive(:turn_right).and_call_original
      simulation.process_command('PLACE 1, 2, WEST')
      simulation.process_command('RIGHT')

      expect(robot).to have_attributes(
        facing: 'north'
      )
    end

    it 'prints the robot position to standard out on REPORT' do
      expect($stdout).to receive(:puts).with('1,2,WEST')
      simulation.process_command('PLACE 1, 2, WEST')
      simulation.process_command('REPORT')
    end

    it 'ignores MOVE if it robot would move off the table' do
      expect(robot).to_not receive(:move_forward)

      simulation.process_command('PLACE 0, 2, WEST')
      simulation.process_command('MOVE')

      expect(robot).to have_attributes(
        x_position: 0,
        y_position: 2,
        facing: 'west'
      )
    end

    it 'ignores REPORT commands until placed' do
      expect($stdout).to_not receive(:puts)

      simulation.process_command('REPORT')
    end

    it 'raises InvalidCommandError on unknown commands' do
      expect { simulation.process_command('PIZZA') }
        .to raise_error(
          Simulation::InvalidCommandError,
          'unexpected command PIZZA'
        )
    end

    it 'raises InvalidCommandError on invalid placement' do
      expect { simulation.process_command('PLACE -1, -1, EAST') }
        .to raise_error(
          Simulation::InvalidCommandError,
          /unable to place robot off the table with command:/
        )

      expect { simulation.process_command('PLACE 6, 6, NORTH') }
        .to raise_error(
          Simulation::InvalidCommandError,
          /unable to place robot off the table with command:/
        )
    end
  end

  # The following can be considered to be integration tests
  #
  shared_examples 'it reports the correct robot position' do
    it 'reports the correct robot position' do
      expect($stdout).to receive(:puts).with(expected_report)

      simulation.process_commands(commands)
    end
  end

  context 'basic commands' do
    let(:commands) do
      <<~COMMANDS
        PLACE 0,0,NORTH
        MOVE
        REPORT
      COMMANDS
    end

    let(:expected_report) { '0,1,NORTH' }

    it_behaves_like 'it reports the correct robot position'
  end

  context 'only turn commands' do
    let(:commands) do
      <<~COMMANDS
        PLACE 0,0,NORTH
        LEFT
        REPORT
      COMMANDS
    end

    let(:expected_report) { '0,0,WEST' }

    it_behaves_like 'it reports the correct robot position'
  end

  context 'more commands' do
    let(:commands) do
      <<~COMMANDS
        PLACE 1,2,EAST
        MOVE
        MOVE
        LEFT
        MOVE
        REPORT
      COMMANDS
    end

    let(:expected_report) { '3,3,NORTH' }

    it_behaves_like 'it reports the correct robot position'
  end

  context '360 turns' do
    let(:commands) do
      <<~COMMANDS
        PLACE 1,2,EAST
        LEFT
        LEFT
        LEFT
        LEFT
        RIGHT
        RIGHT
        RIGHT
        RIGHT
        REPORT
      COMMANDS
    end

    let(:expected_report) { '1,2,EAST' }

    it_behaves_like 'it reports the correct robot position'
  end

  context 'ignore commands which lead the robot to fall off the table' do
    let(:commands) do
      <<~COMMANDS
        PLACE 0,0,SOUTH
        MOVE
        RIGHT
        MOVE
        RIGHT
        MOVE
        MOVE
        MOVE
        MOVE
        MOVE
        MOVE
        RIGHT
        MOVE
        MOVE
        MOVE
        MOVE
        MOVE
        MOVE
        RIGHT
        MOVE
        MOVE
        MOVE
        MOVE
        MOVE
        MOVE
        RIGHT
        MOVE
        MOVE
        MOVE
        MOVE
        MOVE
        MOVE
        REPORT
      COMMANDS
    end

    let(:expected_report) { '0,0,WEST' }

    it_behaves_like 'it reports the correct robot position'
  end

  context 'ignores commands before PLACE' do
    let(:commands) do
      <<~COMMANDS
        MOVE
        LEFT
        RIGHT
        MOVE
        REPORT
        PLACE 1,2,EAST
        MOVE
        MOVE
        LEFT
        MOVE
        LEFT
        REPORT
      COMMANDS
    end

    let(:expected_report) { '3,3,WEST' }

    it_behaves_like 'it reports the correct robot position'
  end

  context 'can be PLACEed multiple times' do
    let(:commands) do
      <<~COMMANDS
        PLACE 0,0,EAST
        MOVE
        PLACE 4,4,EAST
        LEFT
        MOVE
        PLACE 1,2,EAST
        MOVE
        MOVE
        LEFT
        MOVE
        LEFT
        LEFT
        MOVE
        REPORT
      COMMANDS
    end

    let(:expected_report) { '3,2,SOUTH' }

    it_behaves_like 'it reports the correct robot position'
  end
end

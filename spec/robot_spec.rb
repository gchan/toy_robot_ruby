# frozen_string_literal: true

require 'spec_helper'
require 'robot'

RSpec.describe Robot do
  subject(:robot) { described_class.new }

  let(:x) { 3 }
  let(:y) { 3 }
  let(:facing) { 'west' }

  def place_robot
    robot.place(x_position: x, y_position: y, facing: facing)
  end

  shared_context "it isn't placed" do
    it "it isn't placed" do
      expect(robot).to have_attributes(
        x_position: nil,
        y_position: nil,
        facing: nil
      )
    end
  end

  describe '.new' do
    it_behaves_like "it isn't placed"
  end

  describe '#place' do
    context 'with valid position and facing' do
      it 'sets the correct position and facing direction' do
        place_robot

        expect(robot).to have_attributes(
          x_position: x,
          y_position: y,
          facing: facing
        )
      end
    end

    context 'with non-Integer x position' do
      let(:x) { 3.141 }

      it 'raises an ArgumentError' do
        expect { place_robot }
          .to raise_error(ArgumentError, 'x_position is not an Integer')
      end
    end

    context 'with non-Integer y position' do
      let(:y) { [42] }

      it 'raises an ArgumentError' do
        expect { place_robot }
          .to raise_error(ArgumentError, 'y_position is not an Integer')
      end
    end

    context 'with invalid facing direction' do
      let(:facing) { 'towards the ceiling' }

      it 'raises an ArgumentError' do
        expect { place_robot }
          .to raise_error(ArgumentError, /facing is not one of: north/)
      end
    end
  end

  describe '#placed?' do
    context 'when unplaced' do
      it { is_expected.to_not be_placed }
    end

    context 'when placed' do
      before { place_robot }

      it { is_expected.to be_placed }
    end
  end

  describe '#next_position' do
    subject { robot.next_position }

    context 'when unplaced' do
      it_behaves_like "it isn't placed"
    end

    context 'when placed' do
      before { place_robot }

      context 'facing north' do
        let(:facing) { 'north' }

        it { is_expected.to eq({ x_position: 3, y_position: 4 }) }
      end

      context 'facing east' do
        let(:facing) { 'east' }

        it { is_expected.to eq({ x_position: 4, y_position: 3 }) }
      end

      context 'facing south' do
        let(:facing) { 'south' }

        it { is_expected.to eq({ x_position: 3, y_position: 2 }) }
      end

      context 'facing west' do
        let(:facing) { 'west' }

        it { is_expected.to eq({ x_position: 2, y_position: 3 }) }
      end
    end
  end

  describe '#move_forward' do
    context 'when unplaced' do
      before { robot.move_forward }

      it_behaves_like "it isn't placed"
    end

    context 'when placed' do
      before do
        place_robot
        robot.move_forward
      end

      context 'facing north' do
        let(:facing) { 'north' }

        it 'moves up' do
          expect(robot).to have_attributes(
            x_position: x,
            y_position: y + 1,
            facing: facing
          )
        end
      end

      context 'facing east' do
        let(:facing) { 'east' }

        it 'moves right' do
          expect(robot).to have_attributes(
            x_position: x + 1,
            y_position: y,
            facing: facing
          )
        end
      end

      context 'facing south' do
        let(:facing) { 'south' }

        it 'moves down' do
          expect(robot).to have_attributes(
            x_position: x,
            y_position: y - 1,
            facing: facing
          )
        end
      end

      context 'facing west' do
        let(:facing) { 'west' }

        it 'moves left' do
          expect(robot).to have_attributes(
            x_position: x - 1,
            y_position: y,
            facing: facing
          )
        end
      end
    end
  end

  describe '#turn_left' do
    context 'when unplaced' do
      before { robot.turn_left }

      it_behaves_like "it isn't placed"
    end

    context 'when placed' do
      before do
        place_robot
        robot.turn_left
      end

      context 'facing north' do
        let(:facing) { 'north' }

        it 'faces west' do
          expect(robot.facing).to eq('west')
        end
      end

      context 'facing west' do
        let(:facing) { 'west' }

        it 'faces south' do
          expect(robot.facing).to eq('south')
        end
      end

      context 'facing south' do
        let(:facing) { 'south' }

        it 'faces east' do
          expect(robot.facing).to eq('east')
        end
      end

      context 'facing east' do
        let(:facing) { 'east' }

        it 'faces north' do
          expect(robot.facing).to eq('north')
        end
      end
    end
  end

  describe '#turn_right' do
    context 'when unplaced' do
      before { robot.turn_right }

      it_behaves_like "it isn't placed"
    end

    context 'when placed' do
      before do
        place_robot
        robot.turn_right
      end

      context 'facing north' do
        let(:facing) { 'north' }

        it 'faces east' do
          expect(robot.facing).to eq('east')
        end
      end

      context 'facing east' do
        let(:facing) { 'east' }

        it 'faces south' do
          expect(robot.facing).to eq('south')
        end
      end

      context 'facing south' do
        let(:facing) { 'south' }

        it 'faces west' do
          expect(robot.facing).to eq('west')
        end
      end

      context 'facing west' do
        let(:facing) { 'west' }

        it 'faces north' do
          expect(robot.facing).to eq('north')
        end
      end
    end
  end
end

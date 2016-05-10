require 'spec_helper'
require 'timecop'
require 'vortex'
require 'metacosm/support/spec_harness'

describe Vortex do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).to_not be_empty
  end
end

describe ApplicationTemplate do
  subject(:template) { ApplicationTemplate.new(greeting: greeting) }

  let(:greeting) { 'hi there' }

  let(:view) { template.show }

  let(:welcome_message) do
    view.detect do |element|
      element.is_a?(Dedalus::Elements::Heading)
    end
  end

  it 'should greet you' do
    expect(welcome_message.text).to eq(greeting)
  end
end

# TODO test commands/events...
describe JumpCommand do
  subject(:jump_command) do
    JumpCommand.create(player_id: 'the_player_id')
  end

  let(:player_jumped) do
    PlayerUpdatedEvent.create(
      player_id: 'the_player_id',
      velocity: [0.0,-42],
      color: 'color',
      updated_at: Time.now,
      game_id: 'the_game_id',
      name: "Bob",
      acceleration: [0,0],
      location: [ 5.0, 8.0 ]
    )
  end


  after do
    Timecop.return
  end

  before do
    Timecop.freeze(Time.local(1990))
    GameView.create(active_player_id: 'the_player_id')
    Metacosm::Simulation.current.params[:active_player_id] = 'the_player_id'

    game = Game.create(id: 'the_game_id')
    game.create_player(
      name: 'Bob',
      id: 'the_player_id',
      velocity: [0.0,0.0],
      acceleration: [0,0],
      updated_at: Time.now,
      location: [5.0,9.0],
      color: 'color'
    )
  end

  it 'should make the player jump' do
    expect(jump_command).to trigger_event(player_jumped)
  end
end

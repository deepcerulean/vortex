require 'dedalus'

require 'vortex/version'

require 'vortex/models/world'
require 'vortex/models/map'
require 'vortex/models/player'

require 'vortex/organisms/play_field'
require 'vortex/templates/application_template'
require 'vortex/screens/application_screen'

require 'vortex/application_view'
require 'vortex/application'

module Vortex
  class CreateWorldCommand < Metacosm::Command
    attr_accessor :world_id, :name
  end

  class CreateWorldCommandHandler
    def handle(world_id:, name:)
      p [ :create_world! ]
      # world_map = Map.generate(10,10)
      World.create(
        id: world_id,
        name: name,
        # map: world_map
      )
      true
    end
  end

  # neat that this 'just works'! metacosm++
  class WorldCreatedEvent < Metacosm::Event
    attr_accessor :world_id, :name
  end

  class WorldCreatedEventListener < Metacosm::EventListener
    def receive(world_id:, name:)
      p [ :world_created! ]
      WorldView.create(world_id: world_id, name: name, player_id: simulation.params[:active_player_id])
    end
  end

  class MapGeneratedEvent < Metacosm::Event
    attr_accessor :world_id, :grid
  end

  class MapGeneratedEventListener < Metacosm::EventListener
    def receive(world_id:, grid:)
      p [ :map_generated! ]
      world_view = WorldView.find_by(player_id: simulation.params[:active_player_id])
      world_view.update(map_grid: grid)
    end
  end

  class WorldView < Metacosm::View
    attr_accessor :world_id, :name, :map_grid, :player_id
    has_many :player_views
  end

  class CreatePlayerCommand < Metacosm::Command
    attr_accessor :player_id, :world_id, :name
  end

  class CreatePlayerCommandHandler
    def handle(player_id:, world_id:, name:)
      world = World.find(world_id)
      world.create_player(id: player_id, name: name, location: [15,9], velocity: [0.0,0.0], updated_at: Time.now)
    end
  end

  class PlayerView < Metacosm::View
    attr_accessor :player_id, :name, :location, :velocity, :updated_at, :apparent_location
    belongs_to :world_view
  end

  class PlayerCreatedEvent < Metacosm::Event
    attr_accessor :player_id, :world_id, :name, :location, :velocity, :updated_at
  end

  class PlayerCreatedEventListener < Metacosm::EventListener
    def receive(world_id:, player_id:, name:, location:, velocity:, updated_at:)
      p [ :player_created! ]
      world_view = WorldView.find_by(world_id: world_id)
      world_view.create_player_view(player_id: player_id, name: name, location: location, velocity: velocity, updated_at: updated_at)
    end
  end

  class MovePlayerCommand < Metacosm::Command
    attr_accessor :player_id, :world_id, :direction
  end

  class MovePlayerCommandHandler
    def handle(player_id:, world_id:, direction:)
      world = World.find(world_id)
      world.move_player(player_id: player_id, direction: direction)
    end
  end

  class PlayerUpdatedEvent < Metacosm::Event
    attr_accessor :player_id, :world_id, :location, :velocity, :updated_at
  end

  class PlayerUpdatedEventListener < Metacosm::EventListener
    def receive(player_id:, world_id:, location:, velocity:, updated_at:)
      world_view = WorldView.find_by(world_id: world_id)
      player_view = world_view.player_views.where(player_id: player_id).first
      player_view.update(location: location, velocity: velocity, updated_at: updated_at)
    end
  end

  class HaltPlayerCommand < Metacosm::Command
    attr_accessor :player_id, :world_id
  end

  class HaltPlayerCommandHandler
    def handle(player_id:, world_id:)
      world = World.find(world_id)
      world.halt_player(player_id: player_id)
    end
  end

  # TODO ...
  # the players logic will have to mirror what the joyce example program
  # does, pinging etc
  #
  # class Server < Joyce::Server
  # end
end

require 'dedalus'

require 'vortex/version'

require 'vortex/models/world'
require 'vortex/models/map'

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
      WorldView.create(id: world_id, name: name, player_id: simulation.params[:active_player_id])
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
  end

  # TODO ...
  # class Server < Joyce::Server
  # end
end

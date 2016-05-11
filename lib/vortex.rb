require 'dotenv'
Dotenv.load

if !ENV['RACK_ENV'] # i.e., we are not on heroku
  require 'gosu'
end

require 'dedalus'

require 'vortex/version'

require 'vortex/physics'

require 'vortex/models/world'
require 'vortex/models/map'
require 'vortex/models/player'
require 'vortex/models/game'

require 'vortex/views/game_view'
require 'vortex/views/player_view'
require 'vortex/views/world_view'

require 'vortex/molecules/player_avatar'
require 'vortex/molecules/map_tile'
require 'vortex/organisms/play_field'
require 'vortex/templates/application_template'
require 'vortex/screens/application_screen'

require 'vortex/application_view'
require 'vortex/application'

require 'vortex/server'

require 'vortex/commands/ping_command'

module Vortex
  GROUND_LEVEL = 10

  class PingCommandHandler
    def handle(player_id:, player_name:)
      game = Game.find_by(players: { id: player_id })

      if game.nil?
        game = Game.first || Game.create
        game.create_player(
          id: player_id,
          name: player_name,
          location: [1,GROUND_LEVEL],
          velocity: [0.0,0.0],
          acceleration: [0,0],
          updated_at: Time.now,
        )
      end

      game.ping(player_id: player_id)
    end
  end

  class AppEventListener < Metacosm::EventListener
    def game_view
      GameView.find_by(active_player_id: simulation.params[:active_player_id])
    end
  end

  # neat that this 'just works'! metacosm++
  class WorldCreatedEvent < Metacosm::Event
    attr_accessor :world_id, :name, :game_id
  end

  class WorldCreatedEventListener < AppEventListener # Metacosm::EventListener
    def receive(world_id:, name:, game_id:)
      p [ :world_created! ]
      game_view.create_world_view(world_id: world_id, name: name)
    end
  end

  class MapGeneratedEvent < Metacosm::Event
    attr_accessor :world_id, :grid, :game_id
  end

  class MapGeneratedEventListener < AppEventListener
    def receive(world_id:, grid:, game_id:)
      # p [ :map_generated! ]
      world_view = game_view.world_view || game_view.create_world_view
      world_view.update(world_id: world_id, map_grid: grid, redraw_tiles: true)
      # p [ :world_view, :updated_with_map!, world_view ]
    end
  end

  class PlayerCreatedEvent < Metacosm::Event
    attr_accessor :player_id, :game_id, :name, :color, :location, :velocity, :acceleration, :updated_at
  end

  class PlayerCreatedEventListener < AppEventListener
    def receive(game_id:, player_id:, name:, color:, location:, velocity:, acceleration:, updated_at:)
      # p [ :player_created! ]
      game_view.update(game_id: game_id) if game_view.game_id.nil?
      game_view.create_player_view(player_id: player_id, name: name, location: location, velocity: velocity, acceleration: acceleration, updated_at: updated_at, color: color)
    end
  end

  class MovePlayerCommand < Metacosm::Command
    attr_accessor :player_id, :game_id, :direction
  end

  class MovePlayerCommandHandler
    def handle(player_id:, game_id:, direction:)
      game = Game.find(game_id)
      if game
        game.move_player(player_id: player_id, direction: direction)
      end
    end
  end

  class PlayerUpdatedEvent < Metacosm::Event
    attr_accessor :player_id, :game_id, :color, :location, :acceleration, :velocity, :updated_at, :name
  end

  class PlayerUpdatedEventListener < AppEventListener
    def receive(player_id:, game_id:, location:, acceleration:, velocity:, color:, updated_at:, name:)
      player_view = game_view.player_views.where(player_id: player_id).first_or_create
      # p [ :player_updated,
      #     location: location,
      #     location_diff: [player_view.location[0] - location[0], player_view.location[1] - location[1]],
      #     velocity: velocity,
      #     velocity_diff: [player_view.velocity[0] - velocity[0], player_view.velocity[1] - velocity[1]],
      #     acceleration: acceleration ] if player_view.location && location

      player_view.update(location: location, name: name, velocity: velocity, acceleration: acceleration, updated_at: updated_at, color: color)
    end
  end

  # class PlayerMovedEvent < PlayerUpdatedEvent; end
  # class PlayerJumpedEvent < PlayerUpdatedEvent; end

  class PlayerDroppedEvent < Metacosm::Event
    attr_accessor :player_id
  end

  class PlayerDroppedEventListener < AppEventListener
    def receive(player_id:)
      player_view = game_view.player_views.where(player_id: player_id).first
      if player_view
        player_view.destroy
      end
    end
  end

  class JumpCommand < Metacosm::Command
    attr_accessor :player_id #, :game_id
  end

  class JumpCommandHandler
    def handle(player_id:) #, game_id:)
      player = Player.find(player_id)
      player.jump if player
    end
  end

  class DestroyTileCommand < Metacosm::Command
    attr_accessor :game_id, :location, :player_id
  end

  class DestroyTileCommandHandler
    def handle(game_id:, location:, player_id:)
      game = Game.find(game_id)
      if game
        game.destroy_tile(player_id: player_id, location: location)
      end
    end
  end
end

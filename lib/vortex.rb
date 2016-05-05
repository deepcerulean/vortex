require 'dotenv'
Dotenv.load

require 'dedalus'

require 'vortex/version'

require 'vortex/models/world'
require 'vortex/models/map'
require 'vortex/models/player'
require 'vortex/models/game'

require 'vortex/views/game_view'
require 'vortex/views/player_view'
require 'vortex/views/world_view'

require 'vortex/molecules/player_avatar'
require 'vortex/organisms/play_field'
require 'vortex/templates/application_template'
require 'vortex/screens/application_screen'

require 'vortex/application_view'
require 'vortex/application'

require 'vortex/extend/metacosm/simulation'

module Vortex
  class PingCommand < Metacosm::Command
    attr_accessor :player_id, :player_name
  end

  class PingCommandHandler
    def handle(player_id:, player_name:)
      game = Game.find_by(players: { id: player_id })

      if game.nil?
        game = Game.first || Game.create
        game.create_player(id: player_id, name: player_name, location: [15,9], velocity: [0.0,0.0], updated_at: Time.now)
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
      # game_view = GameView.where(game_id: game_id, active_player_id: simulation.params[:active_player_id]).first_or_create
      game_view.create_world_view(world_id: world_id, name: name)
    end
  end

  class MapGeneratedEvent < Metacosm::Event
    attr_accessor :world_id, :grid, :game_id
  end

  class MapGeneratedEventListener < AppEventListener # Metacosm::EventListener
    def receive(world_id:, grid:, game_id:)
      p [ :map_generated! ]
      # game_view = GameView.where(game_id: game_id, active_player_id: simulation.params[:active_player_id]).first_or_create
      world_view = game_view.world_view || game_view.create_world_view
      world_view.update(world_id: world_id, map_grid: grid)
      p [ :world_view, :updated_with_map!, world_view ]
    end
  end

  class PlayerCreatedEvent < Metacosm::Event
    attr_accessor :player_id, :game_id, :name, :color, :location, :velocity, :updated_at
  end

  class PlayerCreatedEventListener < AppEventListener # Metacosm::EventListener
    def receive(game_id:, player_id:, name:, color:, location:, velocity:, updated_at:)
      p [ :player_created! ]
      # game_view = GameView.where(game_id: game_id, active_player_id: simulation.params[:active_player_id]).first_or_create #player_id)
      game_view.update(game_id: game_id) if game_view.game_id.nil?
      # game_view.create
      game_view.create_player_view(player_id: player_id, name: name, location: location, velocity: velocity, updated_at: updated_at, color: color)
    end
  end

  class MovePlayerCommand < Metacosm::Command
    attr_accessor :player_id, :game_id, :direction
  end

  class MovePlayerCommandHandler
    def handle(player_id:, game_id:, direction:)
      game = Game.find(game_id)
      game.move_player(player_id: player_id, direction: direction)
    end
  end

  class PlayerUpdatedEvent < Metacosm::Event
    attr_accessor :player_id, :game_id, :color, :location, :velocity, :updated_at, :name
  end

  class PlayerUpdatedEventListener < AppEventListener # Metacosm::EventListener
    def receive(player_id:, game_id:, location:, velocity:, color:, updated_at:, name:)
      # p [ :update_player, location: location, velocity: velocity ]
      # game_view = GameView.find_by(game_id: game_id)
      player_view = game_view.player_views.where(player_id: player_id).first_or_create
      player_view.update(location: location, name: name, velocity: velocity, updated_at: updated_at, color: color)
    end
  end

  class HaltPlayerCommand < Metacosm::Command
    attr_accessor :player_id, :game_id
  end

  class HaltPlayerCommandHandler
    def handle(player_id:, game_id:)
      game = Game.find(game_id)
      if game
        game.halt_player(player_id: player_id)
      end
    end
  end

  # TODO ...
  class Server < Joyce::Server
    def setup
      p [ :server_setup! ]
      sim.disable_local_events
      drive!
      join
    end

    def tick
      # p [ :server_tick! ]
      @ticks ||= 0
      @ticks = @ticks + 1
      Game.all.each(&:iterate!) if @ticks % 30 == 0
    end
  end
end

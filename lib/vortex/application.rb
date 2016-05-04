module Vortex
  class Application < Joyce::Application
    viewed_with Vortex::ApplicationView

    attr_accessor :last_moved_player_at

    def setup(*)
      # fire(create_world)
      # fire(create_player)

      GameView.create(active_player_id: player_id)
      sim.params[:active_player_id] ||= player_id
    end

    def tick
      # update all views...
      view.apply_velocities!

      if player_view && player_view.velocity != [0,0] && !(pressing?(Gosu::KbLeft) || pressing?(Gosu::KbRight))
        fire(halt_player)
      end

      @ticks ||= 0
      @ticks += 1
      if (@ticks % 10 == 0)
        fire(PingCommand.create(player_id: player_id, player_name: player_name))
      end
    end

    def player_view
      view.game_view.player_views.where(player_id: player_id).first #_or_create
    end

    def pressing?(key)
      window.button_down?(key)
    end

    def press(key)
      if key == Gosu::KbLeft
        fire(move_player(:left))
      elsif key == Gosu::KbRight
        fire(move_player(:right))
      end
    end

    def player_id
      @player_id ||= SecureRandom.uuid
    end

    def player_name
      @player_name ||= %w[ Alice Bob Carol Dan Edgar Francine George Helga India Juanita Kramer ].sample
    end

    private
    def create_world
      CreateWorldCommand.create(world_id: world_id, name: "Hello")
    end

    def create_player
      CreatePlayerCommand.create(player_id: player_id, game_id: game_view.game_id, name: "Bob")
    end

    def move_player(direction)
      MovePlayerCommand.create(player_id: player_id, game_id: game_view.game_id, direction: direction)
    end

    def halt_player
      HaltPlayerCommand.create(player_id: player_id, game_id: game_view.game_id)
    end

    def game_view
      GameView.find_by(active_player_id: player_id)
    end

    def self.connect_immediately?
      true
    end
  end
end
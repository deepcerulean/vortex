module Vortex
  class Application < Joyce::Application
    viewed_with Vortex::ApplicationView

    attr_accessor :last_moved_player_at

    def setup(*)
      fire(create_world)
      fire(create_player)

      sim.params[:active_player_id] ||= player_id
    end

    def tick
      # update all views...
      view.apply_velocities!
      @last_moved_player_at ||= Time.now
      if view.player_view.velocity != [0,0] && !(pressing?(Gosu::KbLeft) || pressing?(Gosu::KbRight))
        fire(halt_player)
      end
    end

    def pressing?(key)
      window.button_down?(key)
    end

    def press(key)
      if key == Gosu::KbLeft
        fire(move_player(:left))
        @last_moved_player_at = Time.now
      elsif key == Gosu::KbRight
        fire(move_player(:right))
        @last_moved_player_at = Time.now
      end
    end

    def player_id
      @player_id ||= SecureRandom.uuid
    end

    private
    def create_world
      CreateWorldCommand.create(world_id: world_id, name: "Hello")
    end

    def create_player
      CreatePlayerCommand.create(player_id: player_id, world_id: world_id, name: "Bob")
    end

    def move_player(direction)
      MovePlayerCommand.create(player_id: player_id, world_id: world_id, direction: direction)
    end

    def halt_player
      HaltPlayerCommand.create(player_id: player_id, world_id: world_id)
    end

    def world_id
      @world_id ||= SecureRandom.uuid
    end
  end
end

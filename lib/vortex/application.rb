module Vortex
  class Application < Joyce::Application
    viewed_with Vortex::ApplicationView

    def setup(*)
      GameView.create(active_player_id: player_id)
      sim.params[:active_player_id] ||= player_id
    end

    def tick
      @ticks ||= 0
      @ticks += 1
      if (@ticks % 50 == 0)
        fire(ping) #
      end
    end

    def player_view
      view.game_view.player_views.where(player_id: player_id).first
    end


    def press(key)
      if key == Gosu::KbLeft
        fire(move_player(:left))
      elsif key == Gosu::KbRight
        fire(move_player(:right))
      elsif key == Gosu::KbUp
        _,ay = *player_view.acceleration
        if ay == 0 && !((@last_jumped_at ||= Time.now) > 1.second.ago)
          fire(jump)
          @last_jumped_at = Time.now
        end
      end
    end


    def player_id
      @player_id ||= SecureRandom.uuid
    end

    def player_name
      @player_name ||= %w[ Alice Bob Carol Dan Edgar Francine George Helga India Juanita Kramer ].sample
    end

    private
    def create_player
      CreatePlayerCommand.create(player_id: player_id, game_id: game_view.game_id, name: "Bob")
    end

    def move_player(direction)
      MovePlayerCommand.create(player_id: player_id, game_id: game_view.game_id, direction: direction)
    end

    def ping
      PingCommand.create(player_id: player_id, player_name: player_name)
    end

    def jump
      JumpCommand.create(player_id: player_id)
    end

    def game_view
      GameView.find_by(active_player_id: player_id)
    end

    def self.connect_immediately?
      p [ :connect_immediately? ]
      true
    end
  end
end

module Vortex
  class Application < Joyce::Application
    viewed_with Vortex::ApplicationView

    # TODO move into joyce/dedalus?
    def click
      p [ :app_click ]
      view.click
    end

    def setup(*)
      GameView.create(active_player_id: player_id)
      sim.params[:active_player_id] ||= player_id
    end

    def fire(cmd)
      @last_sent ||= 2.seconds.ago # Time.now
      elapsed = Time.now - @last_sent
      if elapsed > 0.01
        super(cmd)
        @last_sent = Time.now
      else
        # p [ :rate_limited!]
      end
    end

    def tick

      @ticks ||= 0

      unless self.class.connect_immediately?
        Game.all.each(&:iterate!) # if @ticks % 10 == 0
      end
      GameView.all.each(&:iterate)

      if (@ticks % 120 == 0)
        fire(ping) #
      end

      if window.button_down?(Gosu::KbLeft)
        fire(move_player(:left))
      elsif window.button_down?(Gosu::KbRight)
        fire(move_player(:right))
      end

      if window.button_down?(Gosu::MsLeft)
        view.click
      end

      if window.button_down?(Gosu::KbUp)
        fire(jump)
      end

      @ticks += 1
    end

    def player_view
      view.game_view.player_views.where(player_id: player_id).first
    end

    def press(key)
      if key == Gosu::KbLeft
        fire(move_player(:left))
      elsif key == Gosu::KbRight
        fire(move_player(:right))
      end

      if key == Gosu::KbUp
        fire(jump)
      end
    end

    def destroy_tile_at(location:)
      p [ :fire_destroy_tile_command, location: location ]
      fire(destroy_tile_command(location))
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

    def destroy_tile_command(location)
      DestroyTileCommand.create(game_id: game_view.game_id, location: location, player_id: player_id)
    end

    def game_view
      GameView.find_by(active_player_id: player_id)
    end

    def self.connect_immediately?
      # p [ :connect_immediately? ]
      true
    end
  end
end

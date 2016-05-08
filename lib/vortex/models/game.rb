module Vortex
  class Game < Metacosm::Model
    has_one :world
    has_many :players

    after_create { create_world(name: "New Atlantis") }

    def iterate!
      # check for dropped players
      players_to_drop = players.all.select do |player|
        if player && player.pinged_at
          time_since_ping = Time.now - player.pinged_at
          time_since_ping > 3.seconds
          # player.pinged_at < 3.seconds.ago
        else
          false # already dropped?
        end
      end

      players_to_drop.each do |player|
        drop_player(player)
      end

      # send world updates to everyone...
      players.each do |player|
        player.recompute_location
      end

      # TODO maybe only do this when a new player joins?
      # seems excessive to ship it around all the time..
      world.distribute_map
    end

    def ping(player_id:)
      p [ ping_from: player_id ]
      player = players.where(id: player_id).first
      player.ping
    end

    def move_player(player_id:, direction:)
      player = players.where(id: player_id).first
      player.move(direction)
    end

    def halt_player(player_id:)
      player = players.where(id: player_id).first
      player.halt
    end

    private
    def drop_player(player)
      lost_player_id = player.id
      player.destroy

      emit(
        PlayerDroppedEvent.create(
          player_id: lost_player_id
        )
      )
    end
  end
end

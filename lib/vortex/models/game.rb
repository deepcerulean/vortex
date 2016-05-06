module Vortex
  class Game < Metacosm::Model
    has_one :world
    has_many :players

    after_create { create_world(name: "New Atlantis") }

    def iterate!
      # check for dropped players
      players_to_drop = players.all.select do |player|
        player.pinged_at < 3.seconds.ago
      end

      players_to_drop.each do |player|
        drop_player(player)
      end

      # send world updates to everyone...
      players.each(&:recompute_locations)

      # TODO maybe only do this when a new player joins?
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
          player_id: lost_player_id,
          connected_player_list: connected_player_list
        )
      )
    end
  end
end

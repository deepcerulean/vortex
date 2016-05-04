module Vortex
  class Game < Metacosm::Model
    has_one :world
    has_many :players

    after_create { create_world(name: "New Atlantis") }

    def iterate!
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
  end
end

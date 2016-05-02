module Vortex
  class World < Metacosm::Model
    attr_accessor :name, :width, :height
    has_one :map
    has_many :players

    # move to command?
    after_create do
      self.width ||= 25
      self.height ||= 25
      generate_map(width, height)
    end

    def generate_map(width,height)
      self.map = Map.generate(width, height)
      emit(map_generated)
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
    def map_generated
      MapGeneratedEvent.create(world_id: self.id, grid: map.grid)
    end
  end
end

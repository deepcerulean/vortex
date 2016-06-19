module Vortex
  class World < Metacosm::Model
    attr_accessor :name, :width, :height
    has_one :map
    belongs_to :game

    after_create :generate_map

    def generate_map
      self.map ||= Map.generate(width, height)
      emit(map_generated)
    end

    def distribute_map
      if self.map.nil?
        generate_map
      else
        emit(map_generated)
      end
    end

    def remove_tile(location)
      x,y = *location
      map.grid[y][x] = nil
      emit(map_generated)
    end

    private
    def map_generated
      MapGeneratedEvent.create(
        world_id: self.id,
        grid: map.grid,
        game_id: game.id
      )
    end
  end
end

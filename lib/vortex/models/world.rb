module Vortex
  class World < Metacosm::Model
    attr_accessor :name, :width, :height
    has_one :map
    belongs_to :game

    after_create do
      self.width  ||= 10
      self.height ||= 25
      generate_map(width: width, height: height)
    end

    def generate_map(width: 10,height: 10)
      self.map = Map.generate(width, height)
      emit(map_generated)
    end

    def distribute_map
      if self.map.nil?
        generate_map(width, height)
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

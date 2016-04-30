module Vortex
  class World < Metacosm::Model
    attr_accessor :name, :width, :height
    has_one :map

    # move to command?
    after_create do
      self.width ||= 15
      self.height ||= 15
      generate_map(width, height)
    end

    def generate_map(width,height)
      self.map = Map.generate(width, height)
      emit(map_generated)
    end

    private
    def map_generated
      MapGeneratedEvent.create(world_id: self.id, grid: map.grid)
    end
  end
end

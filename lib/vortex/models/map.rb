module Vortex
  class Map < Metacosm::Model
    belongs_to :world
    attr_accessor :grid

    EMPTY = nil
    ROYAL_BLOCK, EMPTIUM, BRICK, CLOUD = *(0..3)

    def self.generate(w,h)
      create(grid: construct_grid(w,h))
    end

    protected
    def self.construct_grid(width,height)
      # p [ :construct_map_grid! ]
      Array.new(height) do |y|
        Array.new(width) do |x|
          generate_cell(x,y)
        end
      end
    end

    def self.generate_cell(x,y)
      if y > GROUND_LEVEL + 1
        BRICK
      else
        EMPTY
      end
    end
  end
end

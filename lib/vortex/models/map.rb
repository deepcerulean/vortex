module Vortex
  class Map < Metacosm::Model
    belongs_to :world
    attr_accessor :grid

    # DEFAULT_WIDTH = 100

    # def ground_level
    #   GROUND_LEVEL
    # end

    EMPTY = nil
    ROYAL_BLOCK, EMPTIUM, BRICK, CLOUD = *(0..3)

    def self.generate(width,height)
      create(grid: construct_grid(width,height)) #DEFAULT_WIDTH,11)) # width,height))
    end

    protected
    def self.construct_grid(width,height)
      p [ :construct_map_grid! ]
      Array.new(height) do |y|
        Array.new(width) do |x|
          generate_cell(x,y)
        end
      end
    end

    # GROUND_LEVEL = 10

    def self.generate_cell(x,y)
      if y > GROUND_LEVEL + 1
        BRICK #:house
      else
        EMPTY
      end
    end
  end
end

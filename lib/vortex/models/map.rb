module Vortex
  class Map < Metacosm::Model
    belongs_to :world
    attr_accessor :grid

    def ground_level
      GROUND_LEVEL
    end

    EMPTY = nil
    ROYAL_BLOCK, EMPTIUM, BRICK, CLOUD = *(0..3)

    def self.generate(width,height)
      create(grid: construct_grid(20,20)) # width,height))
    end

    protected
    def self.construct_grid(width=20,height=20)
      Array.new(height) do |y|
        Array.new(width) do |x|
          generate_cell(x,y)
        end
      end
    end

    GROUND_LEVEL = 10

    def self.generate_cell(x,y)
      if y >= GROUND_LEVEL 
        BRICK #:house
      else
        EMPTY
      end
    end
  end
end

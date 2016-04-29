module Vortex
  class Map < Metacosm::Model
    belongs_to :world
    attr_accessor :grid

    def self.generate(width,height)
      create(grid: construct_grid(width,height))
    end

    protected
    def self.construct_grid(width,height)
      Array.new(height) do |y|
        Array.new(width) do |x|
          generate_cell(x,y)
        end
      end
    end

    GROUND_LEVEL = 10

    def self.generate_cell(x,y)
      if y >= GROUND_LEVEL 
        0 #:house
      else
        nil
      end
    end
  end
end

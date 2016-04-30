module Vortex
  class ApplicationTemplate < Dedalus::Template
    include Dedalus::Elements

    attr_accessor :greeting, :grid

    def show
      layout do
        image_grid
      end
    end

    def layout
      [
        Heading.new(text: greeting),
        yield
      ]
    end

    def image_grid
      p [ grid: grid ]
      ImageGrid.new(tiles_path: 'media/images/tiles.png', grid: grid, tile_width: 64, tile_height: 64)
    end

    def self.description
      'base vortex game template'
    end

    def self.example_data
      {
        greeting: 'hi',
        grid: [[ 0, 1, 2, nil],
               [ nil, 0, 1, 2]]
      }
    end
  end
end

module Vortex
  class ApplicationTemplate < Dedalus::Template
    include Dedalus::Elements

    attr_accessor :greeting, :grid, :scale, :player_views, :camera_location

    def show
      layout { play_field }
    end

    def play_field
      PlayField.new(
        grid: grid,
        camera_location: camera_location,
        scale: scale,
        player_views: player_views,
        tiles_path: 'media/images/tiles.png',
        tile_width: 64,
        tile_height: 64
      )
    end

    def layout
      [
        Heading.new(text: greeting),
        yield
      ]
    end

    def self.description
      'base vortex game template'
    end

    def self.example_data
      {
        greeting: 'hi',
        grid: [[ 0, 1, 2, nil],
               [ nil, 0, 1, 2]],
        scale: 0.3,
        player_views: [{ location: [3, 0], velocity: [0,0] }]
      }
    end
  end
end

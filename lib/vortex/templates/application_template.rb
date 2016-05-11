module Vortex
  class ApplicationTemplate < Dedalus::Template
    include Dedalus::Elements

    attr_accessor :greeting, :grid, :scale, :player_views, :camera_location, :mouse_position, :highlight_position, :redraw_tiles

    def show
      layout
    end

    def cursor
      Icon.for(:arrow_cursor, position: mouse_position)
    end

    def highlight
      Icon.for(:house, position: highlight_position)
    end

    def layout
      layer_stack = Dedalus::LayerStack.new
      layer_stack.push(Dedalus::Layer.new(play_field))
      layer_stack.push(Dedalus::Layer.new([highlight, cursor], freeform: true))
      layer_stack
    end

    def play_field
      [
        Dedalus::Elements::Heading.new(text: "hi there"),
      PlayField.new(
        grid: grid,
        camera_location: camera_location,
        scale: scale,
        player_views: player_views,
        tiles_path: 'media/images/tiles.png',
        tile_width: 64,
        tile_height: 64,
        tile_class: "Vortex::MapTile",
        name: 'app-template-field',
        redraw_tiles: redraw_tiles
      )
      ]
    end

    def self.description
      'base vortex game template'
    end

    def self.example_data
      {
        greeting: 'hi',
        # grid: [[ 1, 2, 3 ]],
        grid: Array.new(5) { Array.new(150) { rand > 0.5 ? 1 : 2 }},
               # [ 0, 1, 2, 1 ],
               # [ 1, 0, 1, 2 ],
               # [ 0, 0, 0, 0 ]],
        scale: 1.0,
        camera_location: [100,-1],
        mouse_position: [100.0,100.0],
        highlight_position: [4,2],
        # scale: 0.3,
        player_views: [{ location: [4, 3], velocity: [0.4,0] }]
      }
    end
  end
end

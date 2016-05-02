module Vortex
  class PlayField < Dedalus::Elements::SpriteField
    include Dedalus::Elements

    attr_accessor :player_location, :player_velocity

    def sprite_map
      { player_location => [player_sprite_data] }
    end

    def sprites
      [ player_sprite_data ]
    end

    # def image_grid
    #   ImageGrid.new(tiles_path: 'media/images/tiles.png', grid: grid, tile_width: 64, tile_height: 64)
    # end

    def player_sprite_data
      {
        path: 'media/images/walk.png',
        frame: player_frame, 
        width: 64,
        height: 64,
        invert_x: invert_player_x?
      }
    end

    def invert_player_x?
      vx,_ = *player_velocity
      vx > 0
    end

    def player_frame
      if player_velocity == [0,0]
        0
      else
        1 + (Gosu::milliseconds / 200 % 4)
      end
    end

    def self.description
      'sprites overlaid on an image grid'
    end

    def self.example_data
      {
        grid: [[0,0,0,0,0],
               [0,0,0,0,0],
               Array.new(5) { nil },
               [1,1,1,1,1]],
        scale: 0.3,
        player_location: [4,2],
        player_velocity: [-0.2,0]
      }
    end
  end
end

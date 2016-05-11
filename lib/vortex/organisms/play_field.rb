module Vortex
  class PlayField < Dedalus::Elements::SpriteField
    include Dedalus::Elements

    attr_accessor :player_views, :name, :redraw_tiles

    def sprite_map
      if player_views
        map = player_views.inject({}) do |hsh, player_view|
          hsh[player_view[:location]] ||= []
          hsh[player_view[:location]] += player_avatar(player_view).elements
          hsh
        end
        map
      else
        {}
      end
    end

    def player_avatar(player_view)
      PlayerAvatar.new(
        name: player_view[:name],
        velocity: player_view[:velocity],
        overlay_color: player_view[:color]
      )
    end

    # def tile_class
    #   @tile_class ||= "Dedalus::Elements::MapTile"
    # end

    def self.description
      'sprites overlaid on an image grid'
    end

    def self.example_data
      {
        grid: [[0,0,0,0,0],
               [0,0,0,0,0],
               Array.new(5) { nil },
               [1,1,1,1,nil]],
        scale: 1.0,
        tiles_path: "media/images/tiles.png",
        tile_width: 64,
        tile_height: 64,
        tile_class: "Vortex::MapTile",
        camera_location: [-2.1,-4.5],
        player_views: [{ location: [4,2], velocity: [-0.2,0] }]
      }
    end
  end
end

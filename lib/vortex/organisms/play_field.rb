module Vortex
  class PlayField < Dedalus::Elements::SpriteField
    include Dedalus::Elements

    attr_accessor :player_views #, :camera_location
    # attr_accessor :player_location, :player_velocity

    # def camera_location; [0,0] end

    # def camera_location
    #   p [ :using_offset! ]
    #   [ 1, 2 ]
    #   # if player_views && player_views.first
    #   #   cx,cy = *player_views.first[:location] #.current.location
    #   #   p [ cx: cx, cy: cy ]
    #   #   [-cx,-cy]
    #   # else
    #   #   p [ :no_player_view ]
    #   #   [2,2]
    #   # end
    # end

    def sprite_map
      if player_views
        map = player_views.inject({}) do |hsh, player_view|
          # p [ sprite_hash: hsh, player_view: player_view ]
          hsh[player_view[:location]] ||= []
          hsh[player_view[:location]] += player_avatar(player_view).elements
          hsh
        end
        # p [ :sprite_map, map ]
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

    def self.description
      'sprites overlaid on an image grid'
    end

    def self.example_data
      {
        grid: [[0,0,0,0,0],
               [0,0,0,0,0],
               Array.new(5) { nil },
               [1,1,1,1,nil]],
        scale: 0.3,
        camera_location: [-2,-2],
        player_views: [{ location: [4,2], velocity: [-0.2,0] }]
      }
    end
  end
end

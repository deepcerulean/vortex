module Vortex
  class ApplicationScreen < Dedalus::Screen
    include Dedalus::Elements

    attr_accessor :grid, :mouse_position
    attr_accessor :highlight_position, :active_player_name, :player_views, :camera_location, :scale, :redraw_tiles
    attr_accessor :active_player_velocity

    def show
      app_template
    end

    def app_template
      ApplicationTemplate.new(
        mouse_position: mouse_position,
        highlight_position: highlight_position,
        greeting: greeting,
        grid: grid,
        player_views: player_views,
        camera_location: camera_location,
        scale: scale || 1.0,

        redraw_tiles: redraw_tiles
      )
    end

    def greeting
      "Hello #{active_player_name}! | velocity: #{active_player_velocity} | pos: #{camera_location}"
    end
  end
end

module Vortex
  class ApplicationView < Dedalus::ApplicationView
    def app_screen
      ApplicationScreen.new(
        grid: grid, 
        mouse_position: mouse_position, 
        player_views: player_view_data,
        active_player_name: application.player_name,
        camera_location: camera,
        scale: scale
      )
    end

    def scale
      0.5
    end

    def tile_size; 64 * scale end

    def camera
      if active_player_view
        # p [ camera_at: active_player_view.current.location ]
        # cam
        cx, cy = *active_player_view.current.location
        # screen center ('middle')
        mx, my = (window.width / 2) / tile_size, (window.height / 2) / tile_size

        [ cx - mx, cy - my ]

      else
        [0,0]
      end
    end

    def grid
      if world_view
        world_view.map_grid
      else
        []
      end
    end

    def player_view_data
      game_view.player_views.all.map do |pv|
        {
          name: pv.name || "Anonymous",
          velocity: pv.current.velocity || [0,0],
          location: pv.current.location || [1,1],
          updated_at: pv.updated_at || Time.now,
          color: pv.color || 'gray'
        } 
      end
    end

    def world_view
      game_view.world_view
    end

    def game_view
      GameView.find_by(active_player_id: application.player_id)
    end

    def active_player_view
      game_view.player_views.where(player_id: application.player_id).first
    end
  end
end

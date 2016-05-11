module Vortex
  class ApplicationView < Dedalus::ApplicationView
    def click
      puts "APP VIEW CLICK"
      p [ :app_view_click ]
      # @click = true
      composer.click_molecule(
        app_screen,
        [window.width, window.height],
        mouse_position: mouse_position
      )
    end

    def app_screen
      redraw_tiles = false
      if world_view && world_view.redraw_tiles
        world_view.update(redraw_tiles: false)
        redraw_tiles = true
      end

      ApplicationScreen.new(
        grid: grid, 
        mouse_position: mouse_position, 
        player_views: player_view_data,
        active_player_name: application.player_name,
        camera_location: camera,
        scale: 1.0,
        highlight_position: highlight_position,
        redraw_tiles: redraw_tiles
      )
    end

    def destroy_tile_at(position:)
      p [ :destroy_tile, at: position ]
      # convert pos to screen location
      location = to_map_location(position: position)
      # p [ :destroy_tile, location: location ]
      application.destroy_tile_at(location: location)
    end

    def to_map_location(position:)
      w,h = tile_size, tile_size
      x,y = *position
      cx,cy = *camera
      # p [ :convert_to_map_coords, position: [x,y], tile_dims: [w,h], cam: [cx,cy] ]
      [ (x / w) + cx, (y / h) + cy ]
    end

    def tile_size; 64 end

    def highlight_tile_at(pos)
      @highlight_position = pos
    end

    def highlight_position
      @highlight_position ||= [0,0]
    end

    def camera
      # return [0,0]
      if active_player_view
        # p [ camera_at: active_player_view.current.location ]
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

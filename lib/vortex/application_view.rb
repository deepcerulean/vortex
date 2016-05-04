module Vortex
  class ApplicationView < Dedalus::ApplicationView
    def app_screen
      ApplicationScreen.new(
        grid: grid, 
        mouse_position: mouse_position, 
        player_views: player_view_data,
        active_player_name: application.player_name
      )
    end

    def apply_velocities!
      if game_view.player_views
        game_view.player_views.each do |player_view|
          x,y = *(player_view.location || [0,0])
          vx,vy = *(player_view.velocity || [0,0])

          dt = Time.now - (player_view.updated_at || Time.now)

          # dt is in secs, so sprite vels are in 'grid cells / sec'
          dx,dy = dt*vx, dt*vy
          player_view.update(apparent_location: [x+dx,y+dy])
        end
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
        # p [ player_view: pv ]
        { 
          name: pv.name || "Anonymous",
          velocity: pv.velocity || [0,0], 
          location: pv.apparent_location || [1,1],
          updated_at: pv.updated_at || Time.now,
          color: pv.color || 'gray'
        } 
      end
      # p [ player_view_data: player_view_data ]
      # player_view_data
    end

    def world_view
      # p [ world_view: game_view.world_view ]
      game_view.world_view
    end

    def game_view
      GameView.find_by(active_player_id: application.player_id)
    end
  end
end

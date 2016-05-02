module Vortex
  class ApplicationView < Dedalus::ApplicationView
    def app_screen
      ApplicationScreen.new(grid: grid, mouse_position: mouse_position, player_location: player_location, player_velocity: player_view.velocity)
    end

    def apply_velocities!
      # just player view for now
      if player_view
        x,y = *player_view.location
        vx,vy = *player_view.velocity
        # p [ player_vel: [vx,vy] ]

        dt = Time.now - player_view.updated_at

        # dt is in secs, so sprite vels are in 'grid cells / sec'
        dx,dy = dt*vx, dt*vy
        # p [ dt: dt, dx: dx, dy: dy, x: x, y: y ]
        player_view.update(apparent_location: [x+dx,y+dy])
      end
    end

    def grid
      world_view.map_grid
    end

    def player_view
      world_view.player_views.where(player_id: application.player_id).first
    end

    def player_location
      if player_view
        player_view.apparent_location
      else
        [0,0]
      end
    end

    def world_view
      WorldView.find_by(player_id: application.player_id)
    end
  end
end

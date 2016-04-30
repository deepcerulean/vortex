module Vortex
  class ApplicationView < Dedalus::ApplicationView
    def app_screen
      ApplicationScreen.new(grid: grid)
    end

    def grid
      world_view.map_grid
    end

    def world_view
      WorldView.find_by(player_id: application.player_id)
    end
  end
end

module Vortex
  class ApplicationView < Dedalus::ApplicationView
    def app_screen
      ApplicationScreen.new(grid: world_view.map_grid)
    end

    def map
      @map ||= [] #  nil # create_map(25,25)
    end

    def world_view
      WorldView.find_by(player_id: application.player_id)
    end
    
    # def create_map(w,h)
    #   Array.new(w) do
    #     Array.new(h) do
    #       rand > 0.5 ? 0 : nil
    #     end
    #   end
    # end
  end
end

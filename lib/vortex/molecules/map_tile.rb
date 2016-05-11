module Vortex
  # needs to be a molecule to get hover/click events!
  class MapTile < Dedalus::Elements::MapTile
    def hover
      # puts "---> hover map tile at #{self.position}!"
      view.highlight_tile_at(position) if view.is_a?(Vortex::ApplicationView)
    end

    def click
      puts "---> CLICK MAP TILE" 
      puts "     at #{self.position}"
      # view.highlight_tile_at(position) if view.is_a?(Vortex::ApplicationView)

      view.destroy_tile_at(position: position)
      # fire destroy tile cmd?
      # fire(destroy...)
    end
  end
end

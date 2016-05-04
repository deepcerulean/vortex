module Vortex
  class WorldView < Metacosm::View
    attr_accessor :world_id, :name, :map_grid
    belongs_to :game_view
  end
end

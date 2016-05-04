module Vortex
  class GameView < Metacosm::View
    attr_accessor :game_id, :active_player_id

    has_one :world_view
    has_many :player_views
  end
end

module Vortex
  class GameView < Metacosm::View
    attr_accessor :game_id, :active_player_id

    has_one :world_view
    has_many :player_views

    def iterate
      player_views.each do |player_view|
        player_view.recompute_location
      end
    end
  end
end

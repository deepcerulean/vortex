module Vortex
  class PlayerView < Metacosm::View
    attr_accessor :player_id, :name, :location, :velocity, :acceleration, :updated_at, :apparent_location, :color
    belongs_to :game_view

    # def color
    #   @color ||= %w[ red green blue ].sample
    # end
  end
end

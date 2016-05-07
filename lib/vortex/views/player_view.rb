module Vortex
  class PlayerView < Metacosm::View
    attr_accessor :player_id, :name, :location, :velocity, :acceleration, :updated_at, :color
    belongs_to :game_view

    def current
      physics.at(Time.now)
    end

    private

    def physics
      Physics.new(
        location: location,
        velocity: velocity,
        acceleration: acceleration,
        t0: updated_at,
        ground_level: Vortex::GROUND_LEVEL
      )
    end
  end
end

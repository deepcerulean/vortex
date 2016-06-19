module Vortex
  class PlayerView < Metacosm::View
    attr_accessor :player_id, :name, :location, :velocity, :acceleration, :updated_at, :color
    belongs_to :game_view

      # after_update {
      #   @body = construct_body
      # }

    def recompute_location
      # b = current
      @location = current.position
      @velocity = current.velocity
      @updated_at = Time.now
    end

    def current
      body.at(Time.now, obstacles: Physicist::SimpleBody.collection_from_tiles(game_view.world_view.map_grid))
    end

    def body
      #      # ... integrate physicist bodies ...
      #      @body ||= construct_body
      #    end
      #    
      #  private

      #  def construct_body
      Physicist::Body.new(
        position: location,
        velocity: velocity,
        dimensions: [2,2],
        # acceleration: acceleration,
        t0: updated_at,
        # grid: game_view.world_view.map_grid,
        # ground_level: Vortex::GROUND_LEVEL
      )
    end
  end
end

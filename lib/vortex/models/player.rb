module Vortex
  class Player < Metacosm::Model
    attr_accessor :name, :location, :velocity, :acceleration, :color, :updated_at, :pinged_at
    belongs_to :game
    before_create :assign_color

    def assign_color
      self.color ||= %w[ red green blue ].sample
    end

    def recompute_location #(map)
      if location != current.position || velocity != current.velocity
        update(
          location: current.position,
          velocity: current.velocity,
          # acceleration: curr.acceleration,
          color: color,
          updated_at: Time.now,
        )
      end
    end

    def ping
      @pinged_at = Time.now
      # update(pinged_at: Time.now)
    end

    def move(direction)
      p [ :player_move, direction ]
      _,vy = *current.velocity
      if direction == :left
        update(velocity: [-move_rate,vy], location: current.position, updated_at: Time.now)
      elsif direction == :right
        update(velocity: [move_rate,vy], location: current.position, updated_at: Time.now)
      else
        raise "Invalid direction #{direction}"
      end
    end

    def jump
      p [ :player_jump! ]
      vx,vy = *current.velocity
      if vy == 0
        vy = -jump_power
        update(velocity: [vx,vy], location: current.position, updated_at: Time.now)
      else
        false
      end
    end

    protected

    def move_rate
      3
    end

    def jump_power
      13
    end

    private
    def current
      body.at(
        Time.now, 
        obstacles: Physicist::SimpleBody.collection_from_tiles(game.world.map.grid),
        fixed_timestep: true,
        planck_time: 0.005
      )
    end

    def body
      Physicist::Body.new(
        position: location,
        velocity: velocity,
        dimensions: [2,2],
        # acceleration: acceleration,
        # grid: game.world.map.grid,
        # ground_level: Vortex::GROUND_LEVEL,
        t0: updated_at
      )
    end
  end
end

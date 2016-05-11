module Vortex
  class Player < Metacosm::Model
    attr_accessor :name, :location, :velocity, :acceleration, :color, :updated_at, :pinged_at
    belongs_to :game
    before_create :assign_color

    def assign_color
      self.color ||= %w[ red green blue ].sample
    end

    def recompute_location #(map)
      curr = current
      update(
        location: curr.location,
        velocity: curr.velocity,
        acceleration: curr.acceleration,
        color: color,
        updated_at: Time.now,
      )
    end

    def ping
      update(pinged_at: Time.now)
    end

    def move(direction)
      _,vy = *current.velocity
      if direction == :left
        update(velocity: [-move_rate,vy], acceleration: current.acceleration, location: current.location, updated_at: Time.now)
      elsif direction == :right
        update(velocity: [move_rate,vy], acceleration: current.acceleration, location: current.location, updated_at: Time.now)
      else
        raise "Invalid direction #{direction}"
      end
    end


    def jump
      p [ :player_jump! ]
      vx,vy = *current.velocity
      if vy == 0
        vy = -jump_power
        update(velocity: [vx,vy], acceleration: current.acceleration, location: current.location, updated_at: Time.now)
      else
        false
      end
    end

    protected

    def move_rate
      7
    end

    def jump_power
      42
    end

    private
    def current
      physics.at(Time.now)
    end

    def physics
      Physics.new(
        location: location,
        velocity: velocity,
        acceleration: acceleration,
        ground_level: Vortex::GROUND_LEVEL,
        t0: updated_at
      )
    end
  end
end

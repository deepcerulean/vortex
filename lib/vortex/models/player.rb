module Vortex
  class Player < Metacosm::Model
    attr_accessor :name, :location, :velocity, :acceleration, :color, :updated_at, :pinged_at
    belongs_to :game
    before_create :assign_color

    def assign_color
      self.color ||= %w[ red green blue ].sample
    end

    def recompute_location #(map)
      current = physics.at(Time.now)

      update(
        location: current.location,
        velocity: current.velocity,
        acceleration: current.acceleration,
        updated_at: Time.now,
        color: color
      )
    end

    def ping
      recompute_location
      # update(pinged_at: Time.now, location: compute_location, updated_at: Time.now)
    end

    def move(direction)
      _,vy = *velocity
      if direction == :left
        update(velocity: [-1,vy], location: compute_location, updated_at: Time.now)
      elsif direction == :right
        update(velocity: [1,vy], location: compute_location, updated_at: Time.now)
      else
        raise "Invalid direction #{direction}"
      end
    end

    def jump
      vx,_ = *velocity
      ax,_ = *acceleration
      update(velocity: [vx,-1], acceleration: [ax,0.1], location: compute_location, updated_at: Time.now)
    end

    private
    def physics
      Physics.new(
        location: location,
        velocity: velocity,
        acceleration: acceleration,
        ground_level: 10,
        t0: updated_at
      )
    end

    def compute_location
      physics.at(Time.now).location
    end
  end
end

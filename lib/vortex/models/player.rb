module Vortex
  class Player < Metacosm::Model
    attr_accessor :name, :location, :velocity, :acceleration, :color, :updated_at, :pinged_at
    belongs_to :game
    before_create :assign_color

    def assign_color
      self.color ||= %w[ red green blue ].sample
    end

    def recompute_location #(map)
      update(
        location: current.location,
        velocity: current.velocity,
        acceleration: current.acceleration,
        updated_at: Time.now,
        color: color
      )
    end

    def ping
      # recompute_location
    end

    def move(direction)
      _,vy = *current.velocity
      if direction == :left
        update(velocity: [-1,vy], location: current.location, updated_at: Time.now)
      elsif direction == :right
        update(velocity: [1,vy], location: current.location, updated_at: Time.now)
      else
        raise "Invalid direction #{direction}"
      end
    end

    def jump
      p [ :player_jump! ]
      vx,_ = *current.velocity
      ax,_ = *current.acceleration
      update(velocity: [vx,-5], acceleration: [ax,9.8], location: current.location, updated_at: Time.now)
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

module Vortex
  class Player < Metacosm::Model
    attr_accessor :name, :location, :velocity, :color, :updated_at, :pinged_at
    belongs_to :game
    before_create :assign_color

    def assign_color
      self.color ||= %w[ red green blue ].sample
    end

    def recompute_locations
      update(updated_at: Time.now, location: compute_location, color: color)
    end

    def ping
      update(pinged_at: Time.now, location: compute_location, updated_at: Time.now)
    end

    def move(direction)
      if direction == :left
        update(velocity: [-1,0], location: compute_location, updated_at: Time.now)
      elsif direction == :right
        update(velocity: [1,0], location: compute_location, updated_at: Time.now)
      else
        raise "Invalid direction #{direction}"
      end
    end

    def jump
      vx,_ = *velocity
      update(velocity: [vx, 1], location: compute_location, updated_at: Time.now)
    end

    def halt
      update(velocity: [0,0], location: compute_location, updated_at: Time.now)
    end

    def compute_location
      x,y = *location
      vx,vy = *velocity
      dt = Time.now - updated_at
      dx,dy = dt*vx, dt*vy
      [x+dx, y+dy]
    end
  end
end

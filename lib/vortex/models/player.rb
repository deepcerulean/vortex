module Vortex
  class Player < Metacosm::Model
    attr_accessor :name, :location, :velocity, :updated_at
    belongs_to :world

    # before_update { self.updated_at ||= Time.now }

    def move(direction)
      if direction == :left
        update(velocity: [-1,0], location: compute_location, updated_at: Time.now)
      elsif direction == :right
        update(velocity: [1,0], location: compute_location, updated_at: Time.now)
      else
        raise "Invalid direction #{direction}"
      end
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

module Vortex
  class Player < Metacosm::Model
    attr_accessor :name, :location, :velocity, :color, :updated_at, :pinged_at
    belongs_to :game
    before_create :assign_color

    def assign_color
      self.color ||= %w[ red green blue ].sample
    end

    def recompute_location(map)
      x,y = compute_location
      vx,vy = *velocity

      # if our y position is <= map ground level 'beneath' me...
      # zero out vy and set y to the top of the ground tile?
      vy = vy + 0.25 # [0,vy + 0.25].max

      if y >= map.ground_level
        y = map.ground_level
        vy = 0
      end

      # apply a little grav?

      update(
        location: [x,y],
        velocity: [vx,vy],
        updated_at: Time.now,
        color: color
      )
    end

    def ping
      update(pinged_at: Time.now, location: compute_location, updated_at: Time.now)
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
      update(velocity: [vx,-1], location: compute_location, updated_at: Time.now)
    end

    # halt left/right movement...
    def halt
      _,vy = *velocity
      update(velocity: [0,vy], location: compute_location, updated_at: Time.now)
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

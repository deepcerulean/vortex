module Vortex
  class Physics
    attr_reader :location, :velocity, :acceleration, :jerk, :ground_level, :t0

    def initialize(
      ground_level:,
      t0:,
      location:,
      velocity:,
      acceleration: [0,0],
      jerk: [0,0]
    )
      @location = location
      @velocity = velocity
      @acceleration = acceleration
      @jerk = jerk
      @ground_level = ground_level
      @t0 = t0
    end

    def gravity
      100.0
    end

    def friction
      5.0 #.0
    end

    def at(t)
      x0,y0 = *location
      vx0,vy0 = *velocity
      ax,ay = *acceleration

      dt = t - t0
      fric = friction * dt
      speed = vx0.abs

      sign = vx0 > 0 ? 1.0 : (vx0 < 0 ? -1.0 : 0.0)
      stopping_distance = (vx0 ** 2) / (2 * friction)

      if fric < (speed/1.7)
        vx0 += (fric * -sign)
      else
        x0 += stopping_distance/2 * sign
        vx0 = 0
      end

      fx,fy = [ax,ay+gravity]

      vx = vx0 + (fx * dt)
      vy = vy0 + (fy * dt)
      x = x0 + (vx * dt) # + ((0.5) * fx * (dt**2))
      y = y0 + (vy * dt) # + ((0.5) * fy * (dt**2))

      # are we standing on something?
      if y > ground_level - 2 # + 0.2
        y = ground_level - 2 # - 0.2
        vy = 0
        ay = 0
      end

      Physics.new(
        location: [x,y],
        velocity: [vx,vy],
        acceleration: [ax,ay],
        t0: t,
        ground_level: ground_level
      )
    end
  end
end

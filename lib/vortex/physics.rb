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
      29.8
    end

    def at(t)
      x0,y0 = *location
      vx0,vy0 = *velocity #drag(velocity,dt)
      ax,ay = *acceleration #inertia(acceleration,dt)

      # slowly bleed away accelerating forces, since
      # now gravity is handled separately...

      dt = t - t0

      # apply drag and inertia
      # ax = inertia(ax,dt)
      # ay = inertia(ay,dt)
      # vx = drag(vx,dt)
      # vy = drag(vy,dt)

      # apply forces!
      fx,fy = [ax,ay+gravity]

      # see if we can factor in resistance cleanly
      # tau = 1.0 # characteristic time (mass/buoyant force)
      # terminal_vel = 0.0

      vx = vx0 + (fx * dt)
      vy = vy0 + (fy * dt)

      x = x0 + (vx0 * dt) + ((0.5) * fx * (dt**2))
      y = y0 + (vy0 * dt) + ((0.5) * fy * (dt**2))

      # are we standing on something?
      if y > ground_level # + 0.2
        y = ground_level # - 0.2
        vy = 0
        ay = 0
      end

      Physics.new(
        location: [x,y],
        velocity: [vx,vy], #drag(vx,dt), drag(vy,dt)],
        acceleration: [ax,ay], #inertia(ax,dt),inertia(ay,dt)],
        t0: t,
        ground_level: ground_level
      )
    end
  end
end

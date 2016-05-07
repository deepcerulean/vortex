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

    def at(t)
      x0,y0 = *location
      vx,vy = *velocity
      ax,ay = *acceleration
      # jx,jy = *jerk

      dt = t - t0

      vy += ay * dt
      vx += ax * dt
      x = x0 + (vx * dt)
      y = y0 + (vy * dt)

      if y >= ground_level - 0.1
        y = ground_level - 0.2
        vy = 0
        ay = 0
        # jy = 0
      end


      # ax += jx * dt
      # ay += jy * dt

      Physics.new(
        location: [x,y],
        velocity: [vx,vy],
        acceleration: [ax,ay],
        t0: t,
        ground_level: ground_level
      )

    # rescue => ex
    #   require 'pry'
    #   binding.pry
    end
  end
end

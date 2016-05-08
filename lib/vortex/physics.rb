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
      9.8 #.8
    end

      # # dry friction...
    def friction
      6.0
    end

    # def friction(v0,dt, coeff: 5.2)
    #   # 0.05  * 
    #   fr = coeff * dt
    #   speed = v0.abs

    #   decel = fr * -(v0 / speed)
    #   stopping_distance = (v0 ** 2) / (2 * coeff) # decel # speed # / decel # dt

    #   if fr < speed
    #     decel
    #     # fr * -(v0 / speed)
    #   elsif (speed*dt) > stopping_distance
    #     p [ :stopping_distance! ]
    #     -v0
    #   end
    # end

    # def inertia(a,dt,coeff:2.0,threshold:0.1)
    #   da = dt*coeff
    # end

    def at(t)
      x0,y0 = *location
      vx0,vy0 = *velocity
      ax,ay = *acceleration

      dt = t - t0
      
      g = gravity

      fric = friction * dt
      speed = vx0.abs

      # how long does it take (from t0...) for friction to reduce speed to zero?
      # is dt > that?
      # stopping_time = t0 + (stopping_distance

      sign = vx0 > 0 ? 1.0 : (vx0 < 0 ? -1.0 : 0.0)
      stopping_distance = (vx0 ** 2) / (2 * friction) # why g??

      # stop_time 
      if fric < (speed/1.6)
        vx0 += (fric * -sign) # -(vx0 / speed))
      else # dt > stopping_time # speed #stopping_distance
        # p [ :stopping_distance]
        x0 += stopping_distance/2 * sign  #(vx0/speed)
        vx0 = 0
      end

      # fric = friction(vx0,dt)

      fx,fy = [ax,ay+g]

      vx = vx0 + (fx * dt)
      vy = vy0 + (fy * dt)
      x = x0 + (vx * dt) # + ((0.5) * fx * (dt**2))
      y = y0 + (vy * dt) # + ((0.5) * fy * (dt**2))

      # are we standing on something?
      if y > ground_level # + 0.2
        y = ground_level # - 0.2
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

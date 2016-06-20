module Vortex
  class Player < Metacosm::Model
    attr_accessor :name, :location, :velocity, :acceleration, :color, :updated_at, :pinged_at
    belongs_to :game
    before_create :assign_color

    def assign_color
      self.color ||= %w[ red green blue ].sample
    end

    def recompute_location
      t = Time.now
      c = current(t)

      update(
        location: c.position,
        velocity: c.velocity,
        color: color,
        updated_at: t
      )
    end

    def ping
      @pinged_at = Time.now
    end

    def move(direction)
      t = Time.now
      c = current(t)
      p [ :player_move, direction ]
      vx,vy = *c.velocity
      return if vx.abs > move_rate
      if direction == :left
        update(velocity: [-move_rate,vy], location: c.position, updated_at: t)
      elsif direction == :right
        update(velocity: [move_rate,vy], location: c.position, updated_at: t)
      else
        raise "Invalid direction #{direction}"
      end
    end

    def jump
      p [ :player_jump! ]
      t = Time.now
      c = current(t)
      vx,vy = *c.velocity
      if vy == 0
        vy = -jump_power
        update(velocity: [vx,vy], location: c.position, updated_at: t)
      end
    end

    protected

    def move_rate
      4.5
    end

    def jump_power
      20
    end

    private
    def current(t)
      body.at(
        t,
        obstacles: Physicist::SimpleBody.collection_from_tiles(game.world.map.grid),
        fixed_timestep: true,
        planck_time: 0.01
      )
    end

    def body
      Physicist::Body.new(
        position: location,
        velocity: velocity,
        dimensions: [2,2],
        t0: updated_at
      )
    end
  end
end

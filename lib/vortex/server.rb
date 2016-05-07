module Vortex
  class Server < Joyce::Server
    def setup
      p [ :server_setup! ]
      sim.disable_local_events
      drive!
      join
    end

    def tick
      @ticks ||= 0
      @ticks = @ticks + 1
      Game.all.each(&:iterate!) if @ticks % 50 == 0
    end
  end
end

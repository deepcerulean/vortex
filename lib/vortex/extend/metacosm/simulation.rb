module Metacosm
  class Simulation
    def redis_connection
      if ENV['REDISTOGO_URL']
        uri = URI.parse(ENV["REDISTOGO_URL"])
        Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)
      else
        super
      end
    end
  end
end

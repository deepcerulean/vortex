module Metacosm
  class Simulation
    def redis_connection
      puts "---> establishing redis connection..."
      if ENV['REDISTOGO_URL']
        puts "---> using redis to go!"
        uri = URI.parse(ENV["REDISTOGO_URL"])
        Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)
      else
        puts "---> using default redis settings..."
        super
      end
    end
  end
end

# puts "---> loading mc sim override"

# module Metacosm
#   class Simulation
#     def redis_connection
#       puts "---> establishing redis connection..."
#       if ENV['REDISTOGO_URL']
#         puts "---> using redis to go!"
#         uri = URI.parse(ENV["REDISTOGO_URL"])
#         puts "---> parsed uri: #{uri}"
#         @redis_conn ||= Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)
#       else
#         puts "---> using default redis settings..."
#         super
#       end
#     end
#   end
# end
# 
# module Joyce
#   class RemoteSim < Metacosm::RemoteSimulation
#     # def initialize
#     #   super(COMMAND_QUEUE, EVENT_STREAM)
#     # end
#   
#     def redis_connection
#       puts "--> remote sim, redis connection!"
#       conn = Metacosm::Simulation.new.redis_connection
#       puts "---> conn => #{conn.inspect}"
#       conn
#     end
#   end
# end

require "app/draco.rb"

def tick(args)
  $world ||= World.new
  $world.tick(args)
end

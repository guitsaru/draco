class UpdateAcceleration < Draco::System
  filter Acceleration

  def tick(args)
    entities.each do |entity|
      entity.acceleration.x += world.wind.speed.speed.fdiv(50)
      entity.acceleration.y -= world.gravity.speed.speed
    end
  end
end

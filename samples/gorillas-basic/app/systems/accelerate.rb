class Accelerate < Draco::System
  filter Acceleration, Position

  def tick(args)
    entities.each do |entity|
      entity.position.x += entity.acceleration.x
      entity.position.y += entity.acceleration.y
    end
  end
end

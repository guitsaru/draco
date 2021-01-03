class HandleRotation < Draco::System
  filter Acceleration, Rotation, Sprite

  def tick(args)
    entities.each do |entity|
      rotation = (args.state.tick_count % 360) * entity.rotation.velocity
      rotation *= -1 if entity.acceleration.x > 0
      entity.sprite.angle = rotation
    end
  end
end

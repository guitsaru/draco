class MoveLasers < Draco::System
  MAX_Y = 720
  MIN_Y = 0

  filter Laser, Position, Speed, Sprite

  def tick(args)
    entities.each do |entity|
      entity.position.y += entity.speed.speed

      if entity.position.y < MIN_Y || entity.position.y > MAX_Y
        world.entities.delete(entity)
      end
    end
  end
end

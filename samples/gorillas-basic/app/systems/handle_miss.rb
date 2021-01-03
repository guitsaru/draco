class HandleMiss < Draco::System
  filter Collides, Position

  def tick(args)
    entities.each do |entity|
      world.entities.delete(entity) if entity.position.y < 0
    end
  end
end

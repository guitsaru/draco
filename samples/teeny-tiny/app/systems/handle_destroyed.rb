class HandleDestroyed < Draco::System
  filter Destroyed

  def tick(args)
    entities.each do |entity|
      explosion = Explosion.new(position: {x: entity.position.x, y: entity.position.y })
      world.entities.delete(entity)
      world.entities.add(explosion)
      args.gtk.queue_sound("sounds/explosion.ogg")
    end
  end
end

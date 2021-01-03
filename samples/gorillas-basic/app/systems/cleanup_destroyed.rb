class CleanupDestroyed < Draco::System
  filter Tag(:destroyed)

  def tick(args)
    entities.each { |entity| world.entities.delete(entity) }
  end
end

class HandleEnemyLaserCollision < Draco::System
  filter PlayerControlled, Destroyable, Position, Sprite

  def tick(args)
    lasers = world.filter(Laser, EnemyOwned)

    entities.each do |entity|
      laser = lasers.find { |laser| collides?(entity, laser) }

      if laser
        entity.components.add(Destroyed.new)
        entity.components.delete(entity.destroyable)
        world.entities.delete(laser)
      end
    end
  end

  def collides?(entity, laser)
    make_rect(entity).intersect_rect?(make_rect(laser))
  end

  def make_rect(entity)
    {
      x: entity.position.x,
      y: entity.position.y,
      w: entity.sprite.w,
      h: entity.sprite.h
    }
  end
end

class EnemyMovement < Draco::System
  MAX_X = 1260
  MIN_X = 20

  filter EnemyAI, Position, Speed, Sprite

  def tick(args)
    entities.each do |entity|
      entity.position.x += entity.speed.speed

      if entity.position.x < MIN_X
        entity.position.x = MIN_X
        entity.speed.speed *= -1
      elsif entity.position.x + entity.sprite.w > MAX_X
        entity.position.x = MAX_X - entity.sprite.w
        entity.speed.speed *= -1
      end
    end
  end
end

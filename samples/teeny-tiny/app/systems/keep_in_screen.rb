class KeepInScreen < Draco::System
  filter Position, Sprite

  MIN_X = 0
  MAX_X = 1280

  def tick(args)
    entities.each do |entity|
      if entity.position.x < MIN_X
        entity.position.x = MIN_X
      elsif entity.position.x + entity.sprite.w > MAX_X
        entity.position.x = MAX_X - entity.sprite.w
      end
    end
  end
end

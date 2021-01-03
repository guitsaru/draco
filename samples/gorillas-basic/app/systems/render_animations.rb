class RenderAnimations < Draco::System
  filter Animated, Position, Size

  def tick(args)
    entities.each do |entity|
      sprite = entity.animated.idle_sprite

      if entity.animated.enabled
        frame = entity.animated.frames[entity.animated.index]
        sprite = frame.last

        entity.animated.frame_tick_count += 1
        if entity.animated.frame_tick_count >= frame.first
          entity.animated.frame_tick_count = 0
          entity.animated.index += 1
        end

        if entity.animated.index >= entity.animated.frames.count
          entity.animated.enabled = false
          entity.animated.index = 0
          entity.components.delete(entity.animated) unless entity.animated.idle_sprite
        end
      end

      args.outputs.sprites << {
        x: entity.position.x,
        y: entity.position.y,
        w: entity.size.width,
        h: entity.size.height,
        path: sprite
      }
    end
  end
end

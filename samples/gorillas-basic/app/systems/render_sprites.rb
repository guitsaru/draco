class RenderSprites < Draco::System
  filter Position, Rendered, Size, Sprite

  def tick(args)
    sprites = entities.map do |entity|
      {
        x: entity.position.x,
        y: entity.position.y,
        w: entity.size.width,
        h: entity.size.height,
        angle: entity.sprite.angle,
        path: entity.sprite.path
      }
    end

    args.outputs.sprites << sprites
  end
end

class RenderSprites < Draco::System
  filter Position, Sprite

  def tick(args)
    raise "RENDERSPRITES NIL" if entities.nil?
    sprites = entities.map do |entity|
      {
        x: entity.position.x,
        y: entity.position.y,
        w: entity.sprite.w,
        h: entity.sprite.h,
        path: entity.sprite.path
      }
    end

    args.outputs.sprites << sprites
  end
end

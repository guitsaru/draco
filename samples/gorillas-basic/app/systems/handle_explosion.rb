class HandleExplosion < Draco::System
  filter Explodes, Position, Size

  def tick(args)
    collidables = world.entities[Collides, Position, Size]
    return unless collidables.any?
    holes = world.entities[Empty, Position, Size]

    entities.each do |entity|
      rect = make_rect(entity)

      collision = collidables.find { |collidable| make_rect(collidable).intersect_rect?(rect) }

      if collision
        in_hole = holes.map { |h| make_rect(h) }.any? { |h| h.scale_rect(0.8, 0.5, 0.5).intersect_rect?(make_rect(collision)) }

        unless in_hole
          world.entities << Hole.new(position: {x: collision.position.x - 20, y: collision.position.y - 20})
          collision.components << Draco::Tag(:destroyed).new
          entity.components << Draco::Tag(:exploded).new
        end
      end
    end
  end

  private
  def make_rect(entity)
    [entity.position.x, entity.position.y, entity.size.width, entity.size.height]
  end
end

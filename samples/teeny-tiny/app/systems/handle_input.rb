class HandleInput < Draco::System
  filter PlayerControlled, Position, Speed

  def tick(args)
    entities.each do |entity|
      speed = entity.speed.speed

      entity.position.x += delta_x(args) * speed

      if args.inputs.keyboard.space
        entity.components[:attacking] || entity.components.add(Attacking.new)
      end
    end
  end

  def delta_x(args)
    delta = 0

    if args.inputs.keyboard.left
      delta -= 1
    end

    if args.inputs.keyboard.right
      delta += 1
    end

    delta
  end
end

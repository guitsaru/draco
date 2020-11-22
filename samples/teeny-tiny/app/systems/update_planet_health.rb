class UpdatePlanetHealth < Draco::System
  def tick(args)
    entity = world.planet
    remaining = entity.countdown.remaining
    percent = remaining / (20 * 60)

    health_w = 300 * percent
    color = if percent < 0.2
      [159, 17, 27]
    else
      [255, 229, 69]
    end

    args.outputs.primitives << [
      {
        x: entity.position.x + 145,
        y: entity.position.y - 22,
        h: 18,
        w: 308,
        r: 45,
        g: 45,
        b: 45
      }.solid,
      {
        x: entity.position.x + 145 + 4,
        y: entity.position.y - 22 + 4,
        h: 10,
        w: health_w,
        r: color[0],
        g: color[1],
        b: color[2]
      }.solid
    ]
  end
end

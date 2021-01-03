class UpdateWind < Draco::System
  def tick(args)
    wind = world.wind
    wind_speed = wind.speed.speed
    wind.solids.solids = [[640, 12, wind_speed * 500 + wind_speed * 10 * rand, 4, 35, 136, 162]]
  end
end

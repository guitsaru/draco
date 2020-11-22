class UpdateCountdown < Draco::System
  filter Countdown

  def tick(args)
    entities.each do |entity|
      next if entity.countdown.remaining == 0
      entity.countdown.remaining -= 1
    end
  end
end

class CleanupAnimations < Draco::System
  filter Animated

  def tick(args)
    entities.each do |entity|
      total_frames = entity.animated.frames.reduce(0) { |total, frame| total + frame[:frames] }
      world.entities.delete(entity) if entity.animated.current_frame > total_frames
    end
  end
end

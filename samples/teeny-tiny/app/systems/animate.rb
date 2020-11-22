class Animate < Draco::System
  filter Animated, Sprite

  def tick(args)
    entities.each do |entity|
      entity.animated.current_frame += 1
      entity.sprite.path = get_current_frame(entity.animated)
    end
  end

  def get_current_frame(animated)
    total_frames = animated.frames.reduce(0) { |total, frame| total + frame[:frames] }
    current_frame = animated.current_frame % total_frames

    frame_count = 0
    timings = animated.frames.reduce({}) do |h, frame|
      h[frame_count] = frame[:path]
      frame_count += frame[:frames]

      h
    end

    timings.reduce { |path, frame| current_frame >= frame[0] ? frame : path }[1]
  end
end

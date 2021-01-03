class RenderBackground < Draco::System
  filter BackgroundColor

  def tick(args)
    entities.each do |entity|
      args.outputs.background_color = entity.background_color.color
    end
  end
end

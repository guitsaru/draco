class RenderLines < Draco::System
  filter Lines, Rendered

  def tick(args)
    entities.each do |entity|
      args.outputs.lines << entity.lines.lines
    end
  end
end

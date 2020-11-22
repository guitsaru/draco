class RenderLabels < Draco::System
  filter Label, Position

  def tick(args)
    raise "RENDERLABELS NIL" if entities.nil?

    labels = entities.map do |entity|
      {
        x: entity.position.x,
        y: entity.position.y,
        text: entity.label.text,
        r: entity.label.color[0],
        g: entity.label.color[1],
        b: entity.label.color[2],
        size_enum: entity.label.size_enum,
        alignment_enum: entity.label.alignment_enum
      }.label
    end

    args.outputs.labels << labels
  end
end

class RenderLabels < Draco::System
  filter Labels

  def tick(args)
    labels = entities.flat_map { |entity| entity.labels.labels.map(&:label) }

    args.outputs.primitives << labels
  end
end

class RenderSolids < Draco::System
  filter Solids, Rendered

  def tick(args)
    entities.each do |entity|
      args.outputs.primitives << entity.solids.solids.map(&:solid)
    end
  end
end

class RenderStaticSolids < Draco::System
  filter Solids, StaticRendered

  def tick(args)
    entities.reject { |entity| entity.static_rendered.rendered }.each do |entity|
      entity.static_rendered.rendered = true
      args.outputs.static_solids << entity.solids.solids
    end
  end
end

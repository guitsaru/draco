class HandleRestart < Draco::System
  def tick(args)
    if args.inputs.keyboard.key_down.r
      args.state.world = SpaceGame.new
    end
  end
end

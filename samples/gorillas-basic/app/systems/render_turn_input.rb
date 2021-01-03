class RenderTurnInput < Draco::System
  FANCY_WHITE = {r: 253, g: 252, b: 253}

  def tick(args)
    turn = world.current_turn.turn
    return unless turn.player
    return if turn.angle_committed && turn.velocity_committed

    x = turn.player.id == world.player_one.id ? 10 : 1120

    labels = [{x: x, y: 710, text: "Angle:    #{turn.angle}_"}.merge(FANCY_WHITE)]

    if turn.angle_committed
      labels << {x: x, y: 690, text: "Velocity: #{turn.velocity}_"}.merge(FANCY_WHITE)
    end

    args.outputs.labels << labels
  end
end

class HandleNextTurn < Draco::System
  filter Collides

  def tick(args)
    turn = world.current_turn.turn
    return unless turn.angle_committed && turn.velocity_committed
    return if entities.any?

    turn.player = next_player(turn)
    turn.angle = ""
    turn.angle_committed = false
    turn.velocity = ""
    turn.velocity_committed = false
  end

  private
  def next_player(turn)
    players = [world.player_one, world.player_two]
    players.delete(turn.player)
    players.first
  end
end

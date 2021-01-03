class HandleInputGameOver < Draco::System
  filter Ephemeral

  def tick(args)
    return unless args.inputs.keyboard.key_down.truthy_keys.any?

    entities.each { |entity| world.entities.delete(entity) }
    world.entities[Draco::Tag(:exploded)].each { |entity| entity.components.delete(entity.exploded) }

    args.outputs.static_solids.clear
    world.systems.delete(HandleInputGameOver)

    world.current_turn.turn.angle = ""
    world.current_turn.turn.velocity = ""
    world.current_turn.turn.angle_committed = false
    world.current_turn.turn.velocity_committed = false
    world.current_turn.turn.first = next_player(world.current_turn.turn.first)

    world.systems << GenerateStage
    world.systems << HandleInput
    world.systems << RenderTurnInput
    world.systems << CheckWin
  end

  private
  def next_player(player)
    remaining = [world.player_one, world.player_two] - [player]
    remaining.first
  end
end

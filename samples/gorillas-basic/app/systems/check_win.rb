class CheckWin < Draco::System
  FANCY_WHITE = [253, 252, 253]

  filter Killable, Tag(:exploded)

  def tick(args)
    return if entities.empty?
    winner = winner(entities)

    winner.score.score += 1
    world.systems.delete(HandleInput)
    world.systems.delete(RenderTurnInput)
    world.systems.delete(CheckWin)

    world.systems << HandleInputGameOver

    label_text = winner.id == world.player_one.id ? "Player 1 Wins!!" : "Player 2 Wins!!"
    game_over_screen = GameOverScreen.new
    game_over_screen.solids.solids << [args.grid.rect, 0, 0, 0, 200]
    game_over_screen.labels.labels = [game_over_screen.labels.labels.first, [640, 340, label_text, 5, 1, FANCY_WHITE]]
    world.entities << game_over_screen
  end

  def winner(entities)
    remaining = [world.player_one, world.player_two] - entities.to_a
    remaining.first
  end
end

class HandleGameWin < Draco::System
  filter EnemyAI

  def tick(args)
    if entities.empty?
      world.systems.delete(HandleInput)
      world.systems.delete(UpdateCountdown)
      world.systems.delete(EnemyCombat)
      world.systems.delete(EnemyMovement)
      world.systems.delete(HandleGameOver)
      world.systems.delete(HandleGameWin)

      world.systems << HandleRestart

      world.entities << GameWin.new
      world.entities << RestartInstructions.new
    end
  end
end

class HandleGameOver < Draco::System
  def tick(args)
    planet = world.planet
    player = world.player

    if player.components[:destroyed] || planet.countdown.remaining == 0
      world.systems.delete(HandleInput)
      world.systems.delete(UpdateCountdown)
      world.systems.delete(EnemyCombat)
      world.systems.delete(EnemyMovement)
      world.systems.delete(HandleGameOver)
      world.systems.delete(HandleGameWin)

      world.systems << HandleRestart

      world.entities << GameOver.new
      world.entities << RestartInstructions.new
    end
  end
end

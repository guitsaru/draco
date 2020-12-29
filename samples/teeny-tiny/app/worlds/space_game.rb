class SpaceGame < Draco::World
  entity Background
  entity Planet, as: :planet
  entity Player, as: :player

  systems UpdateAttackCooldown,
          UpdateCountdown,
          MoveLasers,
          EnemyCombat,
          EnemyMovement,
          HandleInput,
          KeepInScreen,
          SpawnLasers,
          HandleEnemyLaserCollision,
          HandlePlayerLaserCollision,
          HandleDestroyed,
          Animate,
          CleanupAnimations,
          HandleGameOver,
          HandleGameWin,
          RenderSprites,
          UpdatePlanetHealth,
          RenderLabels


  def initialize
    super

    30.times do |i|
      base_x = 20
      base_y = 560
      width = 75

      column = i % 10
      row = i.idiv(10)

      x = base_x + (column * width)
      y = base_y - (row * width)

      @entities << Enemy.new(position: { x: x, y: y })
    end
  end
end

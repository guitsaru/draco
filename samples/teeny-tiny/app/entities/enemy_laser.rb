class EnemyLaser < Draco::Entity
  component EnemyOwned
  component Laser
  component Position
  component Speed, speed: -10
  component Sprite, w: 9, h: 37, path: "sprites/enemy_laser.png"
end

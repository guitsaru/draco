class PlayerLaser < Draco::Entity
  component Laser
  component PlayerOwned
  component Position
  component Speed, speed: 10
  component Sprite, w: 9, h: 37, path: "sprites/player_laser.png"
end

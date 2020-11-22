class Player < Draco::Entity
  component Destroyable
  component PlayerControlled
  component Position, x: 600, y: 35
  component Speed, speed: 7
  component Sprite, w: 66, h: 50, path: "sprites/player.png"
end

class Explosion < Draco::Entity
  component Animated, frames: [
    {frames: 10, path: "sprites/explosion_1.png"},
    {frames: 10, path: "sprites/explosion_2.png"},
    {frames: 10, path: "sprites/explosion_3.png"},
    {frames: 10, path: "sprites/explosion_4.png"},
  ]

  component Position
  component Sprite, w: 66, h: 66, path: "sprites/explosion_1.png"
end

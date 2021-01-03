class Hole < Draco::Entity
  component Animated, enabled: true, frames: [
    [3, "sprites/explosion0.png"],
    [3, "sprites/explosion1.png"],
    [3, "sprites/explosion2.png"],
    [3, "sprites/explosion3.png"],
    [3, "sprites/explosion4.png"],
    [3, "sprites/explosion5.png"],
    [3, "sprites/explosion6.png"],
  ]

  component Empty
  component Ephemeral
  component Position
  component Rendered
  component Size, width: 40, height: 40
  component Sprite, path: "sprites/hole.png"
end

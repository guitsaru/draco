class Banana < Draco::Entity
  component Acceleration
  component Collides
  component Owned
  component Position
  component Rendered
  component Rotation
  component Size, width: 15, height: 15
  component Sprite, path: "sprites/banana.png"
end

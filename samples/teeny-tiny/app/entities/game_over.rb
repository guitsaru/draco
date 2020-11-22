class GameOver < Draco::Entity
  component Position, x: 640, y: 360
  component Label, text: "Game Over", color: [255, 255, 255], size_enum: 4, alignment_enum: 1
end

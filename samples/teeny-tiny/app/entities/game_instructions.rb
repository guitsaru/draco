class GameInstructions < Draco::Entity
  component Label, text: "Left and Right arrow keys to move, spacebar to shoot", color: [255, 255, 255], alignment_enum: 1, size_enum: -1
  component Position, x: 640, y: 175
end

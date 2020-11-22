class GameWin < Draco::Entity
  component Position, x: 640, y: 360
  component Label, text: "The planet is safe! For now...", color: [255, 255, 255], size_enum: 4, alignment_enum: 1
end

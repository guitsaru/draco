class Scoreboard < Draco::Entity
  FANCY_WHITE = [253, 252, 253]

  component Position, x: 0, y: 0
  component Rendered
  component Size, width: 1280, height: 31
  component Solid
  component Solids, solids: [
    [0, 0, 1280, 31, FANCY_WHITE],
    [1, 1, 1279, 29]
  ]
  component Tag(:debug)
end

class GameOverScreen < Draco::Entity
  FANCY_WHITE = [253, 252, 253]

  component Ephemeral
  component Rendered
  component Solids
  component Labels, labels: [
    [640, 370, "Game Over!!", 5, 1, FANCY_WHITE]
  ]
end

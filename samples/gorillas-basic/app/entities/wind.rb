class Wind < Draco::Entity
  FANCY_WHITE = [253, 252, 253]

  component Lines, lines: [640, 30, 640, 0, FANCY_WHITE]
  component Rendered
  component Solids
  component Speed
end

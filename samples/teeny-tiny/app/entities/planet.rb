class Planet < Draco::Entity
  component Countdown, remaining: 20 * 60
  component Label, text: "Planet Health:", color: [255, 255, 255]
  component Position, x: 10, y: 30
end

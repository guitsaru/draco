class Enemy < Draco::Entity
  component Destroyable
  component EnemyAI
  component Position, x: 20, y: 640
  component Speed, speed: 5
  component Sprite, w: 66, h: 50, path: "sprites/enemy_black.png"
end

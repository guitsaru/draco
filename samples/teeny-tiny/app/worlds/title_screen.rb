class TitleScreen < Draco::World
  entity Background
  entity Title
  entity GameStory
  entity GameInstructions
  entity StartGameInstructions

  systems HandleGameStart, RenderLabels, RenderSprites
end

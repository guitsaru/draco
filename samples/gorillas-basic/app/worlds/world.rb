class World < Draco::World
  entity Background
  entity CurrentTurn, as: :current_turn
  entity Gorilla,
    as: :player_one,
    animated: {
      idle_sprite: "sprites/left-idle.png",
      frames: [
        [5, "sprites/left-0.png"],
        [5, "sprites/left-1.png"],
        [5, "sprites/left-2.png"],
      ]
    }

  entity Gorilla,
    as: :player_two,
    animated: {
      idle_sprite: "sprites/right-idle.png",
      frames: [
        [5, "sprites/right-0.png"],
        [5, "sprites/right-1.png"],
        [5, "sprites/right-2.png"],
      ]
    }

  entity Gravity, as: :gravity
  entity Scoreboard
  entity Wind, as: :wind

  systems RenderBackground,
          GenerateStage,
          RenderScores,
          RenderStaticSolids,
          UpdateWind,
          HandleRotation,
          RenderLines,
          RenderSolids,
          RenderLabels,
          Accelerate,
          UpdateAcceleration,
          HandleExplosion,
          HandleMiss,
          CleanupDestroyed,
          RenderSprites,
          RenderAnimations,
          HandleInput,
          RenderTurnInput,
          CheckWin,
          HandleNextTurn
end

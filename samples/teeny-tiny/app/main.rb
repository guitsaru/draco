require "app/lib/draco.rb"

# Components
require "app/components/animated.rb"
require "app/components/attacking.rb"
require "app/components/countdown.rb"
require "app/components/destroyed.rb"
require "app/components/destroyable.rb"
require "app/components/enemy_ai.rb"
require "app/components/enemy_owned.rb"
require "app/components/label.rb"
require "app/components/laser.rb"
require "app/components/player_controlled.rb"
require "app/components/player_owned.rb"
require "app/components/position.rb"
require "app/components/speed.rb"
require "app/components/sprite.rb"

# Entities
require "app/entities/background.rb"
require "app/entities/enemy.rb"
require "app/entities/enemy_laser.rb"
require "app/entities/explosion.rb"
require "app/entities/game_instructions.rb"
require "app/entities/game_story.rb"
require "app/entities/game_over.rb"
require "app/entities/game_win.rb"
require "app/entities/planet.rb"
require "app/entities/player.rb"
require "app/entities/player_laser.rb"
require "app/entities/restart_instructions.rb"
require "app/entities/start_game_instructions.rb"
require "app/entities/title.rb"

# Systems
require "app/systems/animate.rb"
require "app/systems/cleanup_animations.rb"
require "app/systems/enemy_combat.rb"
require "app/systems/enemy_movement.rb"
require "app/systems/handle_destroyed.rb"
require "app/systems/handle_enemy_laser_collision.rb"
require "app/systems/handle_game_start.rb"
require "app/systems/handle_game_over.rb"
require "app/systems/handle_game_win.rb"
require "app/systems/handle_input.rb"
require "app/systems/handle_player_laser_collision.rb"
require "app/systems/handle_restart.rb"
require "app/systems/keep_in_screen.rb"
require "app/systems/move_lasers.rb"
require "app/systems/render_labels.rb"
require "app/systems/render_sprites.rb"
require "app/systems/spawn_lasers.rb"
require "app/systems/update_attack_cooldown.rb"
require "app/systems/update_countdown.rb"
require "app/systems/update_planet_health.rb"

class TitleScreen < Draco::World
  entity Background
  entity Title
  entity GameStory
  entity GameInstructions
  entity StartGameInstructions

  systems HandleGameStart, RenderLabels, RenderSprites
end

class SpaceGame < Draco::World
  entity Background
  entity Planet, as: :planet
  entity Player, as: :player

  systems UpdateAttackCooldown,
          UpdateCountdown,
          MoveLasers,
          EnemyCombat,
          EnemyMovement,
          HandleInput,
          KeepInScreen,
          SpawnLasers,
          HandleEnemyLaserCollision,
          HandlePlayerLaserCollision,
          HandleDestroyed,
          Animate,
          CleanupAnimations,
          HandleGameOver,
          HandleGameWin,
          RenderSprites,
          UpdatePlanetHealth,
          RenderLabels


  def initialize
    super

    30.times do |i|
      base_x = 20
      base_y = 560
      width = 75

      column = i % 10
      row = i.idiv(10)

      x = base_x + (column * width)
      y = base_y - (row * width)

      @entities << Enemy.new(position: { x: x, y: y })
    end
  end
end

def tick(args)
  args.state.world ||= TitleScreen.new

  args.state.world.tick(args)
  # args.outputs.debug << args.gtk.framerate_diagnostics_primitives
end

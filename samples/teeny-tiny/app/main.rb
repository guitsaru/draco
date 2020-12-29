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

# Worlds
require "app/worlds/title_screen.rb"
require "app/worlds/space_game.rb"

def tick(args)
  args.state.world ||= TitleScreen.new

  args.state.world.tick(args)
end

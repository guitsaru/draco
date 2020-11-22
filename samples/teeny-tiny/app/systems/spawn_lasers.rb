class SpawnLasers < Draco::System
  filter Attacking

  def tick(args)
    entities.reject { |entity| entity.attacking.laser_spawned }.each do |entity|
      if entity.components[:player_controlled]
        world.entities << PlayerLaser.new(position: { x: entity.position.x + 30, y: entity.position.y + 60})
        args.gtk.queue_sound("sounds/player_laser.ogg")
      else
        world.entities << EnemyLaser.new(position: { x: entity.position.x - 30, y: entity.position.y - 60})
        args.gtk.queue_sound("sounds/enemy_laser.ogg")
      end

      entity.attacking.laser_spawned = true
    end
  end
end

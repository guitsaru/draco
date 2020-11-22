class UpdateAttackCooldown < Draco::System
  filter Attacking

  def tick(args)
    entities.each do |entity|
      entity.attacking.cooldown -= 1
      entity.components.delete(entity.attacking) if entity.attacking.cooldown <= 0
    end
  end
end

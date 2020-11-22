class EnemyCombat < Draco::System
  FIRE_CHANCE = 1 / 240

  filter EnemyAI

  def tick(args)
    entities.each do |entity|
      next if entity.components[:attacking]

      entity.components << Attacking.new if rand < FIRE_CHANCE
    end
  end
end

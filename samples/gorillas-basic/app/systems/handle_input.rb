class HandleInput < Draco::System
  def tick(args)
    turn = world.current_turn.turn
    return if turn_finished?(turn)

    current_input = current_input(turn)

    if args.inputs.keyboard.key_down.enter
      submit_input(turn)
    elsif args.inputs.keyboard.key_down.backspace
      update_input(turn, current_input[0..-2])
    elsif args.inputs.keyboard.key_down.char
      char = args.inputs.keyboard.key_down.char
      update_input(turn, current_input + char) if (0..9).map(&:to_s).include?(char)
    end
  end

  private
  def submit_input(turn)
    if !turn.angle_committed
      turn.angle_committed = true
    else
      turn.velocity_committed = true
    end

    if turn.velocity_committed && turn.angle_committed
      angle = turn.angle.to_i
      angle = 180 - angle if world.player_two.id == turn.player.id
      velocity = turn.velocity.to_i / 5

      turn.player.animated.enabled = true
      world.entities << Banana.new(
        owned: {owner: turn.player},
        position: {x: turn.player.position.x + 25, y: turn.player.position.y + 60},
        angled: {angle: angle},
        acceleration: {x: angle.vector_x(velocity), y: angle.vector_y(velocity)}
      )
    end
  end

  def current_input(turn)
    if !turn.angle_committed
      turn.angle
    else
      turn.velocity
    end
  end

  def update_input(turn, value)
    if !turn.angle_committed
      turn.angle = value
    else
      turn.velocity = value
    end
  end

  def turn_finished?(turn)
    turn.angle_committed && turn.velocity_committed
  end
end

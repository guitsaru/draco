class RenderScores < Draco::System
  FANCY_WHITE = [253, 252, 253]

  def tick(args)
    args.outputs.labels << [  10, 25, "Score: #{world.player_one.score.score}", 0, 0, FANCY_WHITE]
    args.outputs.labels << [1270, 25, "Score: #{world.player_two.score.score}", 0, 2, FANCY_WHITE]
  end
end

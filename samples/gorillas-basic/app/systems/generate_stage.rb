class GenerateStage < Draco::System
  BUILDING_HEIGHTS = [4, 4, 6, 8, 15, 18, 20]
  BUILDING_ROOM_SIZES = [4, 5, 6, 7]
  BUILDING_ROOM_WIDTH = 10
  BUILDING_ROOM_SPACING = 15
  BUILDING_ROOM_HEIGHT = 15
  BUILDING_SPACING = 1
  FANCY_WHITE = [253, 252, 253]

  def tick(args)
    buildings = []
    buildings << generate_building(BUILDING_SPACING - 20, *random_building_size)

    8.numbers.inject(buildings) do |b, i|
      b << generate_building(BUILDING_SPACING + b.last.position.x + b.last.size.width, *random_building_size)
    end

    world.entities << buildings

    generate_player(world.player_one, buildings[1], :left)
    generate_player(world.player_two, buildings[-3], :right)

    wind_speed = 1.randomize(:ratio, :sign)
    world.wind.speed.speed = 1.randomize(:ratio, :sign)
    world.current_turn.turn.first ||= world.player_one
    world.current_turn.turn.player = world.current_turn.turn.first

    world.systems.delete(GenerateStage)
  end

  private
  def generate_building(x, floors, rooms)
    width = BUILDING_ROOM_WIDTH * rooms + BUILDING_ROOM_SPACING * (rooms + 1)
    height = BUILDING_ROOM_HEIGHT * floors + BUILDING_ROOM_SPACING * (floors + 1)

    building = Building.new(
      position: {x: x, y: 0},
      size: {width: width, height: height},
      solids: {
        solids: [
          [x - 1, 0, width + 2, height + 1, FANCY_WHITE],
          [x, 0, width, height, random_building_color],
          windows_for_building(x, floors, rooms)
        ]
      }
    )
  end

  def generate_player(player, building, id)
    x = building.position.x + building.size.width.fdiv(2)
    y = building.size.height

    player.position.x = x
    player.position.y = y
  end

  def windows_for_building(x, floors, rooms)
    (floors - 1).combinations(rooms - 1).map do |floor, room|
      [
        (x + BUILDING_ROOM_WIDTH * room) + (BUILDING_ROOM_SPACING * (room + 1)),
        (BUILDING_ROOM_HEIGHT * floor) + (BUILDING_ROOM_SPACING * (floor + 1)),
        BUILDING_ROOM_WIDTH,
        BUILDING_ROOM_HEIGHT,
        random_window_color
      ]
    end
  end

  def random_building_color
    [
      [99,   0, 107],
      [35,  64, 124],
      [35, 136, 162],
    ].sample
  end

  def random_building_size
    [BUILDING_HEIGHTS.sample, BUILDING_ROOM_SIZES.sample]
  end

  def random_window_color
    [
      [ 88,  62, 104],
      [253, 224, 187]
    ].sample
  end
end

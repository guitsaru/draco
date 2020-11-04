# Draco

Draco is an Entity Component System for DragonRuby GTK.

An Entity Component System is an architectural framework that decouples game objects from game logic. An allows you to
build game objects through composition. This allows you to easily share small logic components between different game
objects.

## Installation

1. Create a `lib` directory inside your game's `app` directory.
2. Copy `lib/draco.rb` into your new `lib` directory.
3. In your `main.rb` file, require `app/lib/draco.rb`.

## Usage

### Components

Components represent small atomic bits of state. It's better to use many small components than few large components.
These can be shared across many different types of game objects.

```ruby
class Visible < Draco::Component; end
```

`Visible` is an example of a flag component. An entity either has it, or it doesn't. We can also associate data with our
components.

```ruby
class Position < Draco::Component
  attribute :x, default: 0
  attribute :y, default: 0
end

component = Position.new
```

The component's attributes add a getter and setter on the component for ease of use.

```ruby
component.x = 110

component.x
# => 110
```

### Entities

Entities are independant game objects. They consist of a unique id and a list of components.

```ruby
entity = Draco::Entity.new
entity.components << Position.new(x: 50, y: 50)
```

Often we have types of entities that are reused throughout the game. We can define our own subclass in order to automate creating these entities.

```ruby
class Goblin < Draco::Entity
  component Position, x: 50, y: 50
  component Visible
end

goblin = Goblin.new
```

We can override the default values for the given components when initializing a new entity.

```ruby
goblin = Goblin.new(position: {x: 100, y: 100})
```

In order to access the data within our entity's components, the entity has a method named after that component. This is generated based on the
underscored name of the component's class (e.g. `MapLayer` would be `map_layer`).

```ruby
goblin.position.x
# => 100
```

### Systems

Systems encapsulate all of the logic of your game. The system runs on every tick and it's job is to update the state of the entities.

#### Filters

Each system can set a default filter by passing in a list of components. When the world runs the system, it will set the system's entities to the
entities that include all of the given components.

```ruby
class RenderSpriteSystem < Draco::System
  filter Visible, Position, Sprite

  def tick(args)
    # You can also access the world that called the system.
    camera = world.filter([Camera]).first

    entities.each do |entity|
      next unless

      args.outputs.sprites << {
        x: entity.position.x,
        y: entity.position.y,
        w: entity.sprite.w,
        h: entity.sprite.h,
        path: entity.sprite.path
      }
    end
  end

  def entity_in_camera?(entity, camera)
    camera_rect = {x: camera.x, y: camera.y, w: camera.w, h: camera.h}
    entity_rect = {x: entity.position.x, y: entity.position.y, w: entity.sprite.w, h: entity.sprite.h}

    entity_rect.intersect_rect?(camera_rect)
  end
end
```

### Worlds

A world keeps track of all current entities and runs all of the systems on every tick.

```ruby
world = Draco::World.new
world.entities << goblin
world.systems << RenderSpriteSystem

world.tick(args)
```

## Learn More

Here are some good resources to learn about Entity Component Systems

- [Evolve Your Heirarchy](https://cowboyprogramming.com/2007/01/05/evolve-your-heirachy/)
- [Overwatch Gameplay Architecture and Netcode](https://www.youtube.com/watch?v=W3aieHjyNvw)

## Commercial License

Draco is licensed under AGPL. You can purchase the right to use Draco under the [commercial license](https://github.com/guitsaru/draco/blob/master/COMM-LICENSE).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Before submitting a pull request, please read the [contribution guidelines](https://github.com/guitsaru/draco/blob/master/.github/contributing.md).

Bug reports and pull requests are welcome on GitHub at https://github.com/guitsaru/draco. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/guitsaru/draco/blob/master/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the Draco project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/guitsaru/draco/blob/master/CODE_OF_CONDUCT.md).

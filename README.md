# Draco

Draco is an Entity Component System for DragonRuby GTK.

An Entity Component System is an architectural framework that decouples game objects from game logic. An allows you to
build game objects through composition. This allows you to easily share small logic components between different game
objects.

## Sample Application

This repository includes a sample application in `samples/teeny-tiny`.

### Running the sample application

1. Download the [latest release](https://github.com/guitsaru/draco/archive/main.zip) of this repository.
2. Create a copy of DragonRuby GTK in a new folder.
3. Copy the teeny-tiny directory from draco into your new DragonRuby GTK folder. `cp -r draco/samples/teeny-tiny dragonruby/teeny-tiny`.
4. Run it using `./dragonruby teeny-tiny`.

## Installation

1. Create a `lib` directory inside your game's `app` directory.
2. Copy `lib/draco.rb` into your new `lib` directory.
3. In your `main.rb` file, require `app/lib/draco.rb`.

## Support

- Find a bug? [Open an issue](https://github.com/guitsaru/draco/issues).
- Need help? [Start a Discussion](https://github.com/guitsaru/draco/discussions) or [Join us in Discord: Channel #oss-draco](https://discord.gg/vPUNtwfm).

## Versioning

Draco uses [https://semver.org/].

* Major (X.y.z) - Incremented for any backwards incompatible public API changes.
* Minor (x.Y.z) - Incremented for new, backwards compatible, public API enhancements/fixes.
* Patch (x.y.Z) - Incremented for small, backwards compatible, bug fixes.

## Usage

### Components

Components represent small atomic bits of state. It's better to use many small components than few large components.
These can be shared across many different types of game objects.

```ruby
class Visible < Draco::Component; end
```

`Visible` is an example of a tag component. An entity either has it, or it doesn't. We can also associate data with our
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

#### Tag Components

The `Visible` class above is an example of a tag component. These are common enough that we don't necessarily want to
define a bunch of empty component classes. Draco provides a way to generate these classes at runtime.

```ruby
Draco::Tag(:visible)
# => Visible
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
  component Tag(:visible)
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
  filter Tag(:visible), Position, Sprite

  def tick(args)
    # You can also access the world that called the system.
    camera = world.filter([Camera]).first

    sprites = entities.select { |e| entity_in_camera?(e, camera) }.map do |entity|
       {
        x: entity.position.x - camera.position.x,
        y: entity.position.y - camera.position.y,
        w: entity.sprite.w,
        h: entity.sprite.h,
        path: entity.sprite.path
      }
    end

    args.outputs.sprites << sprites
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

Just like with entities, we can define a subclassed template for our world.

```ruby
class Overworld < Draco::World
  entity Goblin
  entity Player, position: { x: 50, y: 50 }, as: :player
  systems RenderSpriteSystem, InputSystem
end

world = Overworld.new
```

### Named Entities

If there are entities that are frequently accessed in our systems, we can give these a name. In the above example, our
player entity has been given the name `player`. We can now access this directly from our world:

```ruby
world.player
```

### Fetching entities by id

In some cases you'll want to keep track of entities by their id, such as when you want to keep track of another entity in a component.

```ruby
entity = Player.new
entity.id
# => 12

world.entities[12] == entity
# => true
```

## Learn More

Here are some good resources to learn about Entity Component Systems

- [Evolve Your Heirarchy](https://cowboyprogramming.com/2007/01/05/evolve-your-heirachy/)
- [Overwatch Gameplay Architecture and Netcode](https://www.youtube.com/watch?v=W3aieHjyNvw)

## Commercial License

Draco is licensed under AGPL. You can purchase the right to use Draco under the [commercial license](https://github.com/guitsaru/draco/blob/master/COMM-LICENSE).

Each purchase comes with free upgrades for the current major version of Draco.

<a class="gumroad-button" href="https://guitsaru.itch.io/draco" target="_blank">Purchase Commercial License</a>

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Before submitting a pull request, please read the [contribution guidelines](https://github.com/guitsaru/draco/blob/master/.github/contributing.md).

Bug reports and pull requests are welcome on GitHub at https://github.com/guitsaru/draco. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/guitsaru/draco/blob/master/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the Draco project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/guitsaru/draco/blob/master/CODE_OF_CONDUCT.md).

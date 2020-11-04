# Public: Draco is an Entity Component System for use in game engines like DragonRuby.
#
# An Entity Component System is an architectural pattern used in game development to decouple behaviour from game objects.
module Draco
  # Public: The version of the library. Draco uses semver to version releases.
  VERSION = "0.1.0"

  # Public: A general purpose game object that consists of a unique id and a collection of Components.
  class Entity
    @default_components = {}
    @@next_id = 1

    # Public: Returns the Integer id of the Entity.
    attr_reader :id

    # Public: Returns the Array of the Entity's components
    attr_reader :components

    # Internal: Resets the default components for each class that inherites Entity.
    #
    # sub - The class that is inheriting Entity.
    #
    # Returns nothing.
    def self.inherited(sub)
      sub.instance_variable_set(:@default_components, {})
    end

    # Public: Adds a default component to the Entity.
    #
    # component - The class of the Component to add by default.
    # defaults - The Hash of default values for the Component data. (default: {})
    #
    # Examples
    #
    #   component(Visible)
    #
    #   component(Position, x: 0, y: 0)
    #
    # Returns nothing.
    def self.component(component, defaults = {})
      @default_components[component] = defaults
    end

    # Internal: Returns the default components for the class.
    def self.default_components
      @default_components
    end

    # Public: Initialize a new Entity.
    #
    # args - A Hash of arguments to pass into the components.
    #
    # Examples
    #
    #   class Player < Draco::Entity
    #     component Position, x: 0, y: 0
    #   end
    #
    #   Player.new(position: {x: 100, y: 100})
    def initialize(args = {})
      @id = args.fetch(:id, @@next_id)
      @@next_id = [@id + 1, @@next_id].max
      @components = []

      self.class.default_components.each do |component, default_args|
        arguments = default_args.merge(args[underscore(component.name.to_s).to_sym] || {})
        @components << component.new(arguments)
      end
    end

    # Public: Serializes the Entity to save the current state.
    #
    # Returns a Hash representing the Entity.
    def serialize
      serialized = {id: id}

      components.each do |component|
        serialized[underscore(component.class.name.to_s).to_sym] = component.serialize
      end

      serialized
    end

    # Public: Returns a String representation of the Entity.
    def inspect
      serialize.to_s
    end

    # Public: Returns a String representation of the Entity.
    def to_s
      serialize.to_s
    end

    # Signature
    #
    # <underscored_component_name>
    #
    # underscored_component_name - The component to access the data from
    #
    # Public: Get the component associated with this Entity.
    # This method will be available for each component.
    #
    # Examples
    #
    #   class Creature < Draco::Entity
    #     component CreatureStats, strength: 10
    #   end
    #
    #   creature = Creature.new
    #   creature.creature_stats
    #
    # Returns the Component instance.

    def method_missing(m, *args, &block)
      component = components.find { |c| underscore(c.class.name.to_s) == m.to_s }
      return component if component

      super
    end

    # Internal: Converts a camel cased string to an underscored string.
    #
    # Examples
    #
    #   underscore("CamelCase")
    #   # => "camel_case"
    #
    # Returns a String.
    def underscore(string)
      string.split("::").last.bytes.map.with_index do |byte, i|
        if byte > 64 && byte < 97
          downcased = byte + 32
          i == 0 ? downcased.chr : "_#{downcased.chr}"
        else
          byte.chr
        end
      end.join
    end
  end

  # Public: The data to associate with an Entity.
  class Component
    @attribute_options = {}

    # Internal: Resets the attribute options for each class that inherits Component.
    #
    # sub - The class that is inheriting Entity.
    #
    # Returns nothing.
    def self.inherited(sub)
      sub.instance_variable_set(:@attribute_options, {})
    end

    # Public: Defines an attribute for the Component.
    #
    # name - The Symbol name of the attribute.
    # options - The Hash options for the Component (default: {}):
    #           :default - The initial value for the attribute if one is not provided.
    #
    # Returns nothing.
    def self.attribute(name, options = {})
      attr_accessor name
      @attribute_options[name] = options
    end

    # Internal: Returns the Hash attribute options for the current Class.
    def self.attribute_options
      @attribute_options
    end

    # Public: Initializes a new Component.
    #
    # values - The Hash of values to set for the Component instance (default: {}).
    #          Each key should be the Symbol name of the attribute.
    #
    # Examples
    #
    #   class Position < Draco::Component
    #     attribute :x, default: 0
    #     attribute :y, default: 0
    #   end
    #
    #   Position.new(x: 100, y: 100)
    def initialize(values = {})
      self.class.attribute_options.each do |name, options|
        value = values.fetch(name.to_sym, options[:default])
        instance_variable_set("@#{name}", value)
      end
    end

    # Public: Serializes the Component to save the current state.
    #
    # Returns a Hash representing the Component.
    def serialize
      attrs = {}

      instance_variables.each do |attr|
        name = attr.to_s.gsub("@", "").to_sym
        attrs[name] = instance_variable_get(attr)
      end

      attrs
    end

    # Public: Returns a String representation of the Component.
    def inspect
      serialize.to_s
    end

    # Public: Returns a String representation of the Component.
    def to_s
      serialize.to_s
    end
  end

  # Public: Systems contain the logic of the game. The System runs on each tick and manipulates the Entities in the World.
  class System
    @filter = []

    # Public: Returns an Array of Entities that match the filter.
    attr_accessor :entities

    # Public: Returns the World this System is running in.
    attr_accessor :world

    # Public: Adds the given Components to the default filter of the System.
    #
    # Returns the current filter.
    def self.filter(*components)
      components.each do |component|
        @filter << component
      end

      @filter
    end

    # Internal: Resets the fuilter for each class that inherits System.
    #
    # sub - The class that is inheriting Entity.
    #
    # Returns nothing.
    def self.inherited(sub)
      sub.instance_variable_set(:@filter, [])
    end

    # Public: Initializes a new System.
    #
    # entities - The Entities to operate on (default: []).
    # world - The World running the System (default: nil).
    def initialize(entities: [], world: nil)
      @entities = entities
      @world = world
    end

    # Public: Runs the System logic for the current game engine tick.
    #
    # This is where the logic is implemented and it should be overriden for each System.
    #
    # context - The context object of the current tick from the game engine. In DragonRuby this is `args`.
    #
    # Returns nothing
    def tick(context); end

    # Public: Serializes the System to save the current state.
    #
    # Returns a Hash representing the System.
    def serialize
      {
        entities: entities.map(&:serialize),
        world: world ? world.serialize : nil
      }
    end

    # Public: Returns a String representation of the System.
    def inspect
      serialize.to_s
    end

    # Public: Returns a String representation of the System.
    def to_s
      serialize.to_s
    end
  end

  # Public: The container for current Entities and Systems.
  class World
    # Public: Returns the Array of Systems.
    attr_reader :systems

    # Public: Returns the Array of Entities.
    attr_reader :entities

    # Public: Initializes a World.
    #
    # entities - The Array of Entities for the World (default: []).
    # systems - The Array of System Classes for the World (default: []).
    def initialize(entities: [], systems: [])
      @entities = entities
      @systems = systems
    end

    # Public: Runs all of the Systems every tick.
    #
    # context - The context object of the current tick from the game engine. In DragonRuby this is `args`.
    #
    # Returns nothing
    def tick(context)
      systems.each do |system|
        entities = filter(system.filter)

        system.new(entities: entities, world: self).tick(context)
      end
    end

    # Public: Finds all Entities that contain all of the given Components.
    #
    # components - An Array of Component classes to match.
    #
    # Returns an Array of matching Entities.
    def filter(components)
      entities.select { |e| (components - e.components.map(&:class)).empty? }
    end

    # Public: Serializes the World to save the current state.
    #
    # Returns a Hash representing the World.
    def serialize
      {
        entities: @entities.map(&:serialize),
        systems: @systems.map { |system| system.name.to_s }
      }
    end

    # Public: Returns a String representation of the World.
    def inspect
      serialize.to_s
    end

    # Public: Returns a String representation of the World.
    def to_s
      serialize.to_s
    end
  end
end

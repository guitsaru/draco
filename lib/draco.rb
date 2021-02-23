# frozen_string_literal: true

# Public: Draco is an Entity Component System for use in game engines like DragonRuby.
#
# An Entity Component System is an architectural pattern used in game development to decouple behavior from objects.
module Draco
  class NotAComponentError < StandardError; end

  # Public: The version of the library. Draco uses semver to version releases.
  VERSION = "0.6.1"

  # Public: A general purpose game object that consists of a unique id and a collection of Components.
  class Entity
    # rubocop:disable Style/ClassVars
    @default_components = {}
    @@next_id = 1

    # Internal: Resets the default components for each class that inherites Entity.
    #
    # sub - The class that is inheriting Entity.
    #
    # Returns nothing.
    def self.inherited(sub)
      super
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

    # Public: Creates a tag Component. If the tag already exists, return it.
    #
    # name - The string or symbol name of the component.
    #
    # Returns a class with subclass Draco::Component.
    def self.Tag(name) # rubocop:disable Naming/MethodName
      Draco::Tag(name)
    end

    class << self
      # Internal: Returns the default components for the class.
      attr_reader :default_components
    end

    # Public: Returns the Integer id of the Entity.
    attr_reader :id

    # Public: Returns the Array of the Entity's components
    attr_reader :components

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
      @subscriptions = []

      setup_components(args)
      after_initialize
    end

    # Internal: Sets up the default components for the class.
    #
    # args - A hash of arguments to pass into the generated components.
    #
    # Returns nothing.
    def setup_components(args)
      @components = ComponentStore.new(self)

      self.class.default_components.each do |component, default_args|
        arguments = default_args.merge(args[Draco.underscore(component.name.to_s).to_sym] || {})
        @components << component.new(arguments)
      end
    end

    # Public: Callback run after the entity is initialized.
    #
    # This is empty by default but is present to allow plugins to tie into.
    #
    # Returns nothing.
    def after_initialize; end

    # Public: Subscribe to an Entity's Component updates.
    #
    # subscriber - The object to notify when Components change.
    #
    # Returns nothing.
    def subscribe(subscriber)
      @subscriptions << subscriber
    end

    # Public: Callback run before a component is added.
    #
    # component - The component that will be added.
    #
    # Returns the component to add.
    def before_component_added(component)
      component
    end

    # Public: Callback run after a component is added.
    #
    # component - The component that was added.
    #
    # Returns the added component.
    def after_component_added(component)
      @subscriptions.each { |sub| sub.component_added(self, component) }
      component
    end

    # Public: Callback run before a component is deleted.
    #
    # component - The component that will be removed.
    #
    # Returns the component to remove.
    def before_component_removed(component)
      component
    end

    # Public: Callback run after a component is deleted.
    #
    # component - The component that was removed.
    #
    # Returns the removed component.
    def after_component_removed(component)
      @subscriptions.each { |sub| sub.component_removed(self, component) }
      component
    end

    # Public: Serializes the Entity to save the current state.
    #
    # Returns a Hash representing the Entity.
    def serialize
      serialized = { class: self.class.name.to_s, id: id }

      components.each do |component|
        serialized[Draco.underscore(component.class.name.to_s).to_sym] = component.serialize
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

    def method_missing(method, *args, &block)
      component = components[method.to_sym]
      return component if component

      super
    end

    def respond_to_missing?(method, _include_private = false)
      !!components[method.to_sym] or super
    end

    # Internal: An Array that notifies it's parent of updates.
    class ComponentStore
      include Enumerable

      # Internal: Initializes a new ComponentStore
      #
      # parent - The object to notify about updates.
      def initialize(parent)
        @components = {}
        @parent = parent
      end

      # Internal: Adds Components to the ComponentStore.
      #
      # Side Effects: Notifies the parent that the components were updated.
      #
      # components - The Component or Array list of Components to add to the ComponentStore.
      #
      # Returns the ComponentStore.
      def <<(*components)
        components.flatten.each { |component| add(component) }

        self
      end

      # Internal: Returns the Component with the underscored Component name.
      #
      # underscored_component - The String underscored version of the Component's class name.
      #
      # Returns the Component instance or nil.
      def [](underscored_component)
        @components[underscored_component]
      end

      # Internal: Adds a Component to the ComponentStore.
      #
      # Side Effects: Notifies the parent that the components were updated.
      #
      # components - The Component to add to the ComponentStore.
      #
      # Returns the ComponentStore.
      def add(component)
        unless component.is_a?(Draco::Component)
          message = component.is_a?(Class) ? " You might need to initialize the component before you add it." : ""
          raise Draco::NotAComponentError, "The given value is not a component.#{message}"
        end

        component = @parent.before_component_added(component)
        name = Draco.underscore(component.class.name.to_s).to_sym
        @components[name] = component
        @parent.after_component_added(component)

        self
      end

      # Internal: Removes a Component from the ComponentStore.
      #
      # Side Effects: Notifies the parent that the components were updated.
      #
      # components - The Component to remove from the ComponentStore.
      #
      # Returns the ComponentStore.
      def delete(component)
        component = @parent.before_component_removed(component)
        name = Draco.underscore(component.class.name.to_s).to_sym
        @components.delete(name)
        @parent.after_component_removed(component)

        self
      end

      # Internal: Returns true if there are no entries in the Set.
      #
      # Returns a boolean.
      def empty?
        @components.empty?
      end

      # Internal: Returns an Enumerator for all of the Entities.
      def each(&block)
        @components.values.each(&block)
      end
    end
    # rubocop:enable Style/ClassVars
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
      super
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
    class << self
      attr_reader :attribute_options
    end

    # Public: Creates a tag Component. If the tag already exists, return it.
    #
    # name - The string or symbol name of the component.
    #
    # Returns a class with subclass Draco::Component.
    def self.Tag(name) # rubocop:disable Naming/MethodName
      Draco::Tag(name)
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
      after_initialize
    end

    # Public: Callback run after the component is initialized.
    #
    # This is empty by default but is present to allow plugins to tie into.
    #
    # Returns nothing.
    def after_initialize; end

    # Public: Serializes the Component to save the current state.
    #
    # Returns a Hash representing the Component.
    def serialize
      attrs = { class: self.class.name.to_s }

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

  # Public: Creates a new empty component at runtime. If the given Class already exists, it reuses the existing Class.
  #
  # name - The symbol or string name of the component. It can be either camelcase or underscored.
  #
  # Returns a Class with superclass of Draco::Component.
  def self.Tag(name) # rubocop:disable Naming/MethodName
    klass_name = camelize(name)

    return Object.const_get(klass_name) if Object.const_defined?(klass_name)

    klass = Class.new(Component)
    Object.const_set(klass_name, klass)
  end

  # Public: Systems contain the logic of the game.
  # The System runs on each tick and manipulates the Entities in the World.
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
      super
      sub.instance_variable_set(:@filter, [])
    end

    # Public: Creates a tag Component. If the tag already exists, return it.
    #
    # name - The string or symbol name of the component.
    #
    # Returns a class with subclass Draco::Component.
    def self.Tag(name) # rubocop:disable Naming/MethodName
      Draco::Tag(name)
    end

    # Public: Initializes a new System.
    #
    # entities - The Entities to operate on (default: []).
    # world - The World running the System (default: nil).
    def initialize(entities: [], world: nil)
      @entities = entities
      @world = world
      after_initialize
    end

    # Public: Callback run after the system is initialized.
    #
    # This is empty by default but is present to allow plugins to tie into.
    #
    # Returns nothing.
    def after_initialize; end

    # Public: Runs the system tick function.
    #
    # context - The context object of the current tick from the game engine. In DragonRuby this is `args`.
    #
    # Returns nothing.
    def call(context)
      before_tick(context)
      tick(context)
      after_tick(context)
      self
    end

    # Public: Callback run before #tick is called.
    #
    # This is empty by default but is present to allow plugins to tie into.
    #
    # context - The context object of the current tick from the game engine. In DragonRuby this is `args`.
    #
    # Returns nothing.
    def before_tick(context); end

    # Public: Runs the System logic for the current game engine tick.
    #
    # This is where the logic is implemented and it should be overriden for each System.
    #
    # context - The context object of the current tick from the game engine. In DragonRuby this is `args`.
    #
    # Returns nothing
    def tick(context); end

    # Public: Callback run after #tick is called.
    #
    # This is empty by default but is present to allow plugins to tie into.
    #
    # Returns nothing.
    def after_tick(context); end

    # Public: Serializes the System to save the current state.
    #
    # Returns a Hash representing the System.
    def serialize
      {
        class: self.class.name.to_s,
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
    @default_entities = []
    @default_systems = []

    # Internal: Resets the default components for each class that inherites Entity.
    #
    # sub - The class that is inheriting Entity.
    #
    # Returns nothing.
    def self.inherited(sub)
      super
      sub.instance_variable_set(:@default_entities, [])
      sub.instance_variable_set(:@default_systems, [])
    end

    # Public: Adds a default Entity to the World.
    #
    # entity - The class of the Entity to add by default.
    # defaults - The Hash of default values for the Entity. (default: {})
    #
    # Examples
    #
    #   entity(Player)
    #
    #   entity(Player, position: { x: 0, y: 0 })
    #
    # Returns nothing.
    def self.entity(entity, defaults = {})
      name = defaults[:as]
      @default_entities.push([entity, defaults])

      attr_reader(name.to_sym) if name
    end

    # Public: Adds default Systems to the World.
    #
    # systems - The System or Array list of System classes to add to the World.
    #
    # Examples
    #
    #   systems(RenderSprites)
    #
    #   systems(RenderSprites, RenderLabels)
    #
    # Returns nothing.
    def self.systems(*systems)
      @default_systems += Array(systems).flatten
    end

    class << self
      # Internal: Returns the default Entities for the class.
      attr_reader :default_entities

      # Internal: Returns the default Systems for the class.
      attr_reader :default_systems
    end

    # Public: Returns the Array of Systems.
    attr_reader :systems

    # Public: Returns the Array of Entities.
    attr_reader :entities

    # Public: Initializes a World.
    #
    # entities - The Array of Entities for the World (default: []).
    # systems - The Array of System Classes for the World (default: []).
    def initialize(entities: [], systems: [])
      default_entities = self.class.default_entities.map do |default|
        klass, attributes = default
        name = attributes[:as]
        entity = klass.new(attributes)
        instance_variable_set("@#{name}", entity) if name

        entity
      end

      @entities = EntityStore.new(self, default_entities + entities)
      @systems = self.class.default_systems + systems
      after_initialize
    end

    # Public: Callback run after the world is initialized.
    #
    # This is empty by default but is present to allow plugins to tie into.
    #
    # Returns nothing.
    def after_initialize; end

    # Public: Callback run before #tick is called.
    #
    # context - The context object of the current tick from the game engine. In DragonRuby this is `args`.
    #
    # Returns the systems to run during this tick.
    def before_tick(_context)
      systems.map do |system|
        entities = filter(system.filter)

        system.new(entities: entities, world: self)
      end
    end

    # Public: Runs all of the Systems every tick.
    #
    # context - The context object of the current tick from the game engine. In DragonRuby this is `args`.
    #
    # Returns nothing
    def tick(context)
      results = before_tick(context).map do |system|
        system.call(context)
      end

      after_tick(context, results)
    end

    # Public: Callback run after #tick is called.
    #
    # This is empty by default but is present to allow plugins to tie into.
    #
    # context - The context object of the current tick from the game engine. In DragonRuby this is `args`.
    # results - The System instances that were run.
    #
    # Returns nothing.
    def after_tick(context, results); end

    # Public: Callback to run when a component is added to an existing Entity.
    #
    # entity - The Entity the Component was added to.
    # component - The Component that was added to the Entity.
    #
    # Returns nothing.
    def component_added(entity, component); end

    # Public: Callback to run when a component is added to an existing Entity.
    #
    # entity - The Entity the Component was removed from.
    # component - The Component that was removed from the Entity.
    #
    # Returns nothing.
    def component_removed(entity, component); end

    # Public: Finds all Entities that contain all of the given Components.
    #
    # components - An Array of Component classes to match.
    #
    # Returns an Array of matching Entities.
    def filter(*components)
      entities[components.flatten]
    end

    # Public: Serializes the World to save the current state.
    #
    # Returns a Hash representing the World.
    def serialize
      {
        class: self.class.name.to_s,
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

    # Internal: Stores Entities with better performance than Array.
    class EntityStore
      include Enumerable

      attr_reader :parent

      # Internal: Initializes a new EntityStore
      #
      # entities - The Entities to add to the EntityStore
      def initialize(parent, *entities)
        @parent = parent
        @entity_to_components = Hash.new { |hash, key| hash[key] = Set.new }
        @component_to_entities = Hash.new { |hash, key| hash[key] = Set.new }
        @entity_ids = {}

        self << entities
      end

      # Internal: Gets all Entities that implement all of the given Components or that match the given entity ids.
      #
      # components_or_ids - The Component Classes to filter by
      #
      # Returns a Set list of Entities
      def [](*components_or_ids)
        components_or_ids
          .flatten
          .map { |component_or_id| select_entities(component_or_id) }
          .reduce { |acc, i| i & acc }
      end

      # Internal: Gets entities by component or id.
      #
      # component_or_id - The Component Class or entity id to select.
      #
      # Returns an Array of Entities.
      def select_entities(component_or_id)
        if component_or_id.is_a?(Numeric)
          Array(@entity_ids[component_or_id])
        else
          @component_to_entities[component_or_id]
        end
      end

      # Internal: Adds Entities to the EntityStore
      #
      # entities - The Entity or Array list of Entities to add to the EntityStore.
      #
      # Returns the EntityStore
      def <<(entities)
        Array(entities).flatten.each { |e| add(e) }
        self
      end

      # Internal: Adds an Entity to the EntityStore.
      #
      # entity - The Entity to add to the EntityStore.
      #
      # Returns the EntityStore
      def add(entity)
        entity.subscribe(self)

        @entity_ids[entity.id] = entity
        components = entity.components.map(&:class)
        @entity_to_components[entity].merge(components)

        components.each { |component| @component_to_entities[component].add(entity) }
        entity.components.each { |component| @parent.component_added(entity, component) }

        self
      end

      # Internal: Removes an Entity from the EntityStore.
      #
      # entity - The Entity to remove from the EntityStore.
      #
      # Returns the EntityStore
      def delete(entity)
        @entity_ids.delete(entity.id)
        components = Array(@entity_to_components.delete(entity))

        components.each do |component|
          @component_to_entities[component].delete(entity)
        end
      end

      # Internal: Returns true if the EntityStore has no Entities.
      def empty?
        @entity_to_components.empty?
      end

      # Internal: Returns an Enumerator for all of the Entities.
      def each(&block)
        @entity_to_components.keys.each(&block)
      end

      # Internal: Updates the EntityStore when an Entity's Components are added.
      #
      # entity - The Entity the Component was added to.
      # component - The Component that was added to the Entity.
      #
      # Returns nothing.
      def component_added(entity, component)
        @component_to_entities[component.class].add(entity)
        @parent.component_added(entity, component)
      end

      # Internal: Updates the EntityStore when an Entity's Components are removed.
      #
      # entity - The Entity the Component was removed from.
      # component - The Component that was removed from the Entity.
      #
      # Returns nothing.
      def component_removed(entity, component)
        @component_to_entities[component.class].delete(entity)
        @parent.component_removed(entity, component)
      end
    end
  end

  # Internal: An implementation of Set.
  class Set
    include Enumerable

    # Internal: Initializes a new Set.
    #
    # entries - The initial Array list of entries for the Set
    def initialize(entries = [])
      @hash = {}
      merge(entries)
    end

    # Internal: Adds a new entry to the Set.
    #
    # entry - The object to add to the Set.
    #
    # Returns the Set.
    def add(entry)
      @hash[entry] = true
      self
    end

    # Internal: Adds a new entry to the Set.
    #
    # entry - The object to add to the Set.
    #
    # Returns the Set.
    def delete(entry)
      @hash.delete(entry)
      self
    end

    # Internal: Adds multiple objects to the Set.
    #
    # entry - The Array list of objects to add to the Set.
    #
    # Returns the Set.
    def merge(entries)
      Array(entries).each { |entry| add(entry) }
      self
    end

    # Internal: alias of merge
    def +(other)
      merge(other)
    end

    # Internal: Returns an Enumerator for all of the entries in the Set.
    def each(&block)
      @hash.keys.each(&block)
    end

    # Internal: Returns true if the object is in the Set.
    #
    # member - The object to search the Set for.
    #
    # Returns a boolean.
    def member?(member)
      @hash.key?(member)
    end

    # Internal: Returns true if there are no entries in the Set.
    #
    # Returns a boolean.
    def empty?
      @hash.empty?
    end

    # Internal: Returns the intersection of two Sets.
    #
    # other - The Set to intersect with
    #
    # Returns a new Set of all of the common entries.
    def &(other)
      response = Set.new
      each do |key, _|
        response.add(key) if other.member?(key)
      end

      response
    end

    def ==(other)
      hash == other.hash
    end

    # Internal: Returns a unique hash value of the Set.
    def hash
      @hash.hash
    end

    # Internal: Returns an Array representation of the Set.
    def to_a
      @hash.keys
    end

    # Internal: Serializes the Set.
    def serialize
      to_a.inspect
    end

    # Internal: Inspects the Set.
    def inspect
      to_a.inspect
    end

    # Internal: Returns a String representation of the Set.
    def to_s
      to_a.to_s
    end
  end

  # Internal: Converts a camel cased string to an underscored string.
  #
  # Examples
  #
  #   underscore("CamelCase")
  #   # => "camel_case"
  #
  # Returns a String.
  def self.underscore(string)
    string.to_s.split("::").last.bytes.map.with_index do |byte, i|
      if byte > 64 && byte < 97
        downcased = byte + 32
        i.zero? ? downcased.chr : "_#{downcased.chr}"
      else
        byte.chr
      end
    end.join
  end

  # Internal: Converts an underscored string into a camel case string.
  #
  # Examples
  #
  #   camlize("camel_case")
  #   # => "CamelCase"
  #
  # Returns a string.
  def self.camelize(string) # rubocop:disable Metrics/MethodLength
    modifier = -32

    string.to_s.bytes.map do |byte|
      if byte == 95
        modifier = -32
        nil
      else
        char = (byte + modifier).chr
        modifier = 0
        char
      end
    end.compact.join
  end
end

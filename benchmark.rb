require_relative "lib/draco"
require "benchmark"

class SampleComponent < Draco::Component
  attribute :a, default: 0
  attribute :b, default: 0
  attribute :c, default: 0
  attribute :d, default: 0
  attribute :e, default: 0
  attribute :f, default: 0
  attribute :g, default: 0
end

class SampleSystem < Draco::System
  filter SampleComponent

  def tick(_)
    entities.each do |entity|
      entity.sample_component.a
    end
  end
end

dynamic_components = (1..1000).map do |i|
  name = "DynamicComponent#{i}"
  klass = Class.new(SampleComponent)

  Object.const_set(name, klass)
  klass
end

class SampleEntity < Draco::Entity
  component SampleComponent
end

dynamic_components.each do |dynamic_component|
  SampleEntity.component(dynamic_component) if [true, false].sample
end

world = Draco::World.new
world.systems << SampleSystem

(1..10000).each do |i|
  entity = SampleEntity.new
  # entity.components << SampleComponent.new
  entity.components << dynamic_components.map { |c| c.new }
  world.entities << entity
end

puts "Goal: #{1.0/60.0}"

Benchmark.bm do |bm|
  bm.report("tick") do
    world.tick(nil)
  end

  bm.report("filter") { world.filter(dynamic_components) }
end

# Initial Implementation
#        user     system      total        real
# tick  0.049613   0.000000   0.049613 (  0.049673)
# filter  0.005983   0.000000   0.005983 (  0.005992)


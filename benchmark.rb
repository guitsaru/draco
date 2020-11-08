# frozen_string_literal: true

require_relative "lib/draco"
require "benchmark"

puts "Defining Component"
class SampleComponent < Draco::Component
  attribute :a, default: 0
  attribute :b, default: 0
  attribute :c, default: 0
  attribute :d, default: 0
  attribute :e, default: 0
  attribute :f, default: 0
  attribute :g, default: 0
end

puts "Defining System"
class SampleSystem < Draco::System
  filter SampleComponent

  def tick(_)
    entities.each do |entity|
      entity.sample_component.a
    end
  end
end

puts "Dynamic Components"
dynamic_components = (1..1000).map do |i|
  name = "DynamicComponent#{i}"
  klass = Class.new(SampleComponent)

  Object.const_set(name, klass)
  klass
end

puts "Defining Entity"
class SampleEntity < Draco::Entity
  component SampleComponent
end

puts "Adding dynamic components to Entity"
dynamic_components.each do |dynamic_component|
  SampleEntity.component(dynamic_component) if [true, false, false, false, false].sample
end

puts "Defining World"
world = Draco::World.new
world.systems << SampleSystem

Benchmark.bm do |bm|
  bm.report("initialize entity") do
    SampleEntity.new
  end
end

puts "Generating 10_000 entities"
(1..10_000).each do |i|
  print "#{i} " if (i % 100).zero?

  entity = SampleEntity.new
  world.entities << entity
end

puts
puts "Goal: #{1.0 / 60.0}"

Benchmark.bm do |bm|
  bm.report("tick") do
    world.tick(nil)
  end

  bm.report("filter") { world.filter(SampleComponent) }
end

# Initial Implementation
#        user     system      total        real
# tick  0.345672   0.006669   0.352341 (  0.354792)
# filter  0.288709   0.000000   0.288709 (  0.290659)

# After optimization
#        user     system      total        real
# tick  0.007575   0.000005   0.007580 (  0.007589)
# filter  0.000013   0.000000   0.000013 (  0.000012)

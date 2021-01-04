# frozen_string_literal: true

class WorldComponent < Draco::Component
  attribute :tested, default: false
end

class FilteredComponent < Draco::Component
  attribute :tested, default: false
end

class AnotherComponent < Draco::Component; end

class WorldEntity < Draco::Entity
  component WorldComponent
end

class FilteredEntity < Draco::Entity
  component FilteredComponent
end

class WorldSystem < Draco::System
  filter WorldComponent

  def tick(_)
    entities.each { |e| e.world_component.tested = true }
  end
end

class SampleWorld < Draco::World
  entity WorldEntity
  entity WorldEntity
  entity FilteredEntity, filtered_component: { tested: true }, as: :filtered_entity
  systems WorldSystem
end

RSpec.describe Draco::World do
  describe "#systems" do
    subject { Draco::World.new.systems }

    it { is_expected.to be_empty }
  end

  describe "#entities" do
    subject { Draco::World.new.entities }

    it { is_expected.to be_empty }
  end

  describe "#tick" do
    let(:filtered_entity) { FilteredEntity.new }
    let(:world_entity) { WorldEntity.new }

    let!(:world) do
      world = Draco::World.new
      world.entities << filtered_entity
      world.entities << world_entity
      world.systems << WorldSystem

      world.tick(nil)
    end

    it "operates on WorldEntity" do
      expect(world_entity.world_component.tested).to be true
    end

    it "doesn't operate on FilteredEntity" do
      expect(filtered_entity.filtered_component.tested).to be false
    end
  end

  describe "#serialize" do
    subject do
      world = Draco::World.new
      world.systems << WorldSystem

      world.serialize
    end

    it "serializes the class" do
      expect(subject[:class]).to eq("Draco::World")
    end

    it { is_expected.to include(:entities) }
    it { is_expected.to include(:systems) }
  end

  describe "#inspect" do
    subject { Draco::World.new.inspect }

    it { is_expected.to be }
  end

  describe "#to_s" do
    subject { Draco::World.new.to_s }

    it { is_expected.to be }
  end

  describe "#entities" do
    let(:entity) do
      entity = Draco::Entity.new
      entity.components << WorldComponent.new
      entity.components << FilteredComponent.new
      entity
    end

    let(:world) do
      world = Draco::World.new
      world.entities << entity
      world
    end

    it "updates component map when entity deletes a component" do
      expect(world.filter([FilteredComponent])).to_not be_empty
      entity.components.delete(entity.filtered_component)

      expect(world.filter([FilteredComponent])).to be_empty
    end

    it "updates component map when entity adds a component" do
      expect(world.filter([AnotherComponent])).to be_empty
      entity.components << AnotherComponent.new

      expect(world.filter([AnotherComponent])).to_not be_empty
    end

    it "can delete an entity" do
      world.entities.delete(entity)
      expect(world.entities).to be_empty
    end
  end

  describe "#filter" do
    let(:entity) do
      entity = Draco::Entity.new
      entity.components << WorldComponent.new
      entity.components << FilteredComponent.new
      entity
    end

    let(:world) do
      world = Draco::World.new
      world.entities << entity
      world
    end

    it "works with one component" do
      expect(world.filter(WorldComponent)).to_not be_empty
    end

    it "works with multiple components" do
      expect(world.filter(WorldComponent, FilteredComponent)).to_not be_empty
    end

    it "works with an entity id" do
      entity = world.entities.first
      expect(world.filter(entity.id)).to_not be_empty
    end
  end

  describe "World Templates" do
    let(:world) { SampleWorld.new }

    it "has default entities" do
      expect(world.entities).to_not be_empty
      expect(world.entities.count).to eq(3)
      expect(world.entities[FilteredComponent].first.filtered_component.tested).to be true
    end

    it "has named entities" do
      expect(world.filtered_entity.filtered_component.tested).to be true
    end

    it "has default systems" do
      expect(world.systems).to_not be_empty
    end
  end
end

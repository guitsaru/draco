# frozen_string_literal: true

class WorldComponent < Draco::Component
  attribute :tested, default: false
end

class FilteredComponent < Draco::Component
  attribute :tested, default: false
end

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
end

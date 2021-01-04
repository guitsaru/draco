# frozen_string_literal: true

class TestComponent < Draco::Component
  attribute :test, default: true
end

class TestEntity < Draco::Entity
  component TestComponent
  component Tag(:test_tag)
end

RSpec.describe Draco::Entity do
  describe ".initialize" do
    let(:entity) { Draco::Entity.new }

    it "has an id" do
      expect(entity.id).to be
    end

    it "has a list of components" do
      expect(entity.components).to be_empty
    end
  end

  describe "#serialize" do
    let(:entity) { TestEntity.new }
    subject { entity.serialize }

    it "serializes the id" do
      expect(subject[:id]).to eq(entity.id)
    end

    it "serialize the class" do
      expect(subject[:class]).to eq("TestEntity")
    end

    it "serializes the components" do
      expect(subject[:test_component]).to be
    end
  end

  describe "#inspect" do
    subject { TestEntity.new.inspect }

    it { is_expected.to be }
  end

  describe "#to_s" do
    subject { TestEntity.new.to_s }

    it { is_expected.to be }
  end

  describe "#<component_name>" do
    subject { TestEntity.new.test_component }

    it { is_expected.to be }
  end

  describe "#<component_name> for Tag component" do
    subject { TestEntity.new.test_tag }

    it { is_expected.to be }
  end

  describe "#method_missing" do
    subject { TestEntity.new }

    it "raises a NoMethodError error with no matching component" do
      expect { subject.no_component }.to raise_error(NoMethodError)
    end
  end
end

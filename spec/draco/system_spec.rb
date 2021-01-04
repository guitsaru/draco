# frozen_string_literal: true

class SampleSystem < Draco::System
  filter SampleComponent
end

class SampleTagSystem < Draco::System
  filter Tag(:test_tag)
end

RSpec.describe Draco::System do
  describe "#entities" do
    subject { SampleSystem.new.entities }

    it { is_expected.to be_empty }
  end

  describe "#world" do
    subject { SampleSystem.new.world }

    it { is_expected.to be_nil }
  end

  describe ".filter" do
    context "default filter" do
      subject { Draco::System.filter }

      it { is_expected.to be_empty }
    end

    context "with a set filter" do
      subject { SampleSystem.filter }

      it { is_expected.to include(SampleComponent) }
    end
  end

  describe "#serialize" do
    subject { SampleSystem.new.serialize }

    it { is_expected.to include(:entities) }
    it { is_expected.to include(:world) }

    it "serializes the class" do
      expect(subject[:class]).to eq("SampleSystem")
    end

    context "with a world" do
      subject { SampleSystem.new(world: Draco::World.new).serialize }

      it { is_expected.to include(:world) }
    end
  end

  describe "#inspect" do
    subject { SampleSystem.new.inspect }

    it { is_expected.to be }
  end

  describe "#to_s" do
    subject { SampleSystem.new.to_s }

    it { is_expected.to be }
  end
end

# frozen_string_literal: true

class SampleComponent < Draco::Component
  attr_reader :test

  attribute :name
  attribute :velocity, default: 0

  def initialize(values = {})
    super
    @test = true
  end
end

RSpec.describe Draco::Component do
  describe "attribute" do
    subject { SampleComponent.new }

    it "defaults to nil" do
      expect(subject.name).to be_nil
    end

    it "defaults to the given default value" do
      expect(subject.velocity).to eq(0)
    end

    it "runs the overridden initializer" do
      expect(subject.test).to be true
    end
  end

  describe "#serialize" do
    subject { SampleComponent.new.serialize }

    it "serializes the class" do
      expect(subject[:class]).to eq("SampleComponent")
    end

    it "serializes the attributes" do
      expect(subject[:name]).to be_nil
      expect(subject[:velocity]).to eq(0)
    end
  end

  describe "#inspect" do
    subject { SampleComponent.new.inspect }

    it { is_expected.to be }
  end

  describe "#to_s" do
    subject { SampleComponent.new.to_s }

    it { is_expected.to be }
  end
end

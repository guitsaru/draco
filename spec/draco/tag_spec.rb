# frozen_string_literal: true

RSpec.describe Draco do
  describe "Tag" do
    subject { Draco::Tag(:destroyed) }

    it "has a name" do
      expect(subject.name).to eq("Destroyed")
    end

    it "creates a component" do
      expect(subject.superclass).to be(Draco::Component)
    end
  end
end

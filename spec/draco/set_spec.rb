# frozen_string_literal: true

# rubocop:disable Lint/BinaryOperatorWithIdenticalOperands

RSpec.describe Draco::Set do
  describe "#&" do
    it "works with empty sets" do
      expect(Set.new([]) & Set.new([])).to be_empty
    end

    it "works with equal sets" do
      expect(Set.new([1, 2]) & Set.new([1, 2])).to eq(Set.new([1, 2]))
    end

    it "works with unequal sets" do
      expect(Set.new([1, 2]) & Set.new([2, 3])).to eq(Set.new([2]))
    end
  end

  describe "#hash" do
    it "has equal hashes" do
      expect(Set.new([1, 2]).hash).to eq(Set.new([1, 2]).hash)
    end

    it "has unequal hashes" do
      expect(Set.new([1]).hash).to_not eq(Set.new([2]).hash)
    end
  end
  # rubocop:enable Lint/BinaryOperatorWithIdenticalOperands
end

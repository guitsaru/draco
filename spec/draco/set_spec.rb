# frozen_string_literal: true

# rubocop:disable Lint/BinaryOperatorWithIdenticalOperands

RSpec.describe Draco::Set do
  describe "#&" do
    it "works with empty sets" do
      expect(Draco::Set.new([]) & Draco::Set.new([])).to be_empty
    end

    it "works with equal sets" do
      expect(Draco::Set.new([1, 2]) & Draco::Set.new([1, 2])).to eq(Draco::Set.new([1, 2]))
    end

    it "works with unequal sets" do
      expect(Draco::Set.new([1, 2]) & Draco::Set.new([2, 3])).to eq(Draco::Set.new([2]))
    end
  end

  describe "#hash" do
    it "has equal hashes" do
      expect(Draco::Set.new([1, 2]).hash).to eq(Draco::Set.new([1, 2]).hash)
    end

    it "has unequal hashes" do
      expect(Draco::Set.new([1]).hash).to_not eq(Draco::Set.new([2]).hash)
    end
  end

  describe "#serialize" do
    subject { Draco::Set.new([1]).serialize }

    it { is_expected.to eq("[1]") }
  end

  describe "#to_s" do
    subject { Draco::Set.new([1]).to_s }

    it { is_expected.to eq("[1]") }
  end

  describe "#inspect" do
    subject { Draco::Set.new([1]).inspect }

    it { is_expected.to eq("[1]") }
  end

  # rubocop:enable Lint/BinaryOperatorWithIdenticalOperands
end

class Label < Draco::Component
  attribute :color, default: [0, 0, 0]
  attribute :text, default: ""
  attribute :alignment_enum, default: 0
  attribute :size_enum, default: 0
end

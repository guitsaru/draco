class Turn < Draco::Component
  attribute :angle, default: ""
  attribute :angle_committed, default: false
  attribute :first
  attribute :player
  attribute :velocity, default: ""
  attribute :velocity_committed, default: false
end

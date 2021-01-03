class Animated < Draco::Component
  attribute :enabled, default: false
  attribute :idle_sprite
  attribute :index, default: 0
  attribute :frame_tick_count, default: 0
  attribute :frames, default: []
end

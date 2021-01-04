# frozen_string_literal: true

module Draco
  # Public: Calculates the average time of
  module Benchmark
    def self.included(mod)
      mod.prepend(World)
    end

    # Internal: Plugin implementation for World.
    module World
      def before_tick(context)
        super
        @system_timer_data = Hash.new { |h, k| h[k] = [] }
        @systems.each { |system| system.prepend(System) }
      end

      def after_tick(context, results)
        super
        results.each do |system|
          name = Draco.underscore(system.class.name.to_s).to_sym
          @system_timer_data[name] = (system.timer * 1000.0).round(5)
        end
      end

      def system_timers
        @system_timer_data.sort_by { |_k, v| -v }.to_h
      end
    end

    # Internal: Plugin implementation for System.
    module System
      def after_initialize
        super
        @timer = 0
      end

      def before_tick(context)
        super
        @start_time = Time.now
      end

      def after_tick(context)
        super
        @timer = Time.now - @start_time
      end

      def timer
        @timer
      end
    end
  end
end

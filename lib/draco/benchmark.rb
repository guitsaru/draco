# frozen_string_literal: true

module Draco
  # Public: Calculates the average time of 
  module Benchmark
    def self.included(mod)
      mod.prepend(World)
    end

    module World
      def before_tick(context)
        @system_timer_data = Hash.new { |h, k| h[k] = [] }
        super.each { |system| system.class.prepend(System) }
      end

      def after_tick(context, results)
        super
        results.each do |system|
          name = Draco.underscore(system.class.name.to_s).to_sym
          @system_timer_data[name] = (system.timer * 1000.0).round(5)
        end
        puts @system_timer_data.inspect if context.tick_count % 10 == 0
      end

      def system_timers
        @system_timer_data.sort_by { |k,v| -v }.to_h
      end
    end

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

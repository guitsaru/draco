module Draco
  class World
    attr_accessor :system_timer_data

    old_tick = instance_method(:tick)

    def system_timer(system)
      raise "Enable using #enable_system_timer!" unless @use_system_timer

      a = @system_timer_data[system].last(100)
      a.inject { |sum, n| sum + n } / a.size.to_f
    end

    def system_timers
      raise "Enable using #enable_system_timer!" unless @use_system_timer

      report = {}
      @system_timer_data.keys.each do |k|
        report[k] = (system_timer(k) * 1000.0).round(5)
      end
      report.sort_by { |k,v| -v }.to_h
    end

    def enable_system_timer!
      @system_timer_data ||= {}
      @use_system_timer = true
    end

    def disable_system_timer!
      @system_timer_data = {}
      @use_system_timer = false
    end

    define_method(:tick) do |context|
      if @use_system_timer
        systems.each do |system|
          entities = filter(system.filter)

          start_time = Time.now
          system.new(entities: entities, world: self).tick(context)
          finish_time = Time.now

          elapsed_time = (finish_time - start_time)
          name = Draco.underscore(system.name.to_s).to_sym
          @system_timer_data[name] ||= []
          @system_timer_data[name] << elapsed_time
        end
      else
        old_tick.bind(self).(context)
      end
    end
  end
end

## 0.6.0 (January 5, 2020)

Features:

  - `#serialize` now includes the class name for Entities, Components, and Systems.
  - Added callbacks to Entities, Components, Systems and Worlds to better enable plugins.
  - Added a sample plugin to `lib/draco/benchmark.rb` to benchmark your systems.

    How to use:

    ```ruby
    class World < Draco::World
      include Draco::Benchmark
    end

    world.system_timers
    # => { :system => 0.001 }
    ```

## 0.5.1 (December 31, 2020)

Features:

  - Add an alias to `Draco::Tag` in Entities and Systems.

## 0.5.0 (December 31, 2020)

Features:

  - Add `Draco::Tag` to easily define tag components [#6](https://github.com/guitsaru/draco/pull/6)

# frozen_string_literal: true

require_relative "lib/draco"

Gem::Specification.new do |spec|
  spec.name          = "draco"
  spec.version       = Draco::VERSION
  spec.authors       = ["Matt Pruitt"]
  spec.email         = ["matt@guitsaru.com"]

  spec.summary       = "An ECS library."
  spec.description   = "A library for Entities, Components, and Systems in games."
  spec.homepage      = "https://github.com/guitsaru/draco"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/guitsaru/draco"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|samples)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end

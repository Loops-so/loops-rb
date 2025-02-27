# frozen_string_literal: true

require_relative "lib/loops_sdk/version"

Gem::Specification.new do |spec|
  spec.name = "loops_sdk"
  spec.version = LoopsSdk::VERSION
  spec.authors = ["Dan Rowden"]
  spec.email = ["dan@loops.so"]

  spec.summary = "The official Ruby SDK for Loops."
  spec.description = "A Ruby wrapper for interacting with the Loops API."
  spec.homepage = "https://loops.so/docs/api-reference"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Loops-so/loops-rb"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.glob(%w[lib/**/*.rb README.md LICENSE.txt])
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end

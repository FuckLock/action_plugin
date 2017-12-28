
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "action_plugin/version"

Gem::Specification.new do |spec|
  spec.name          = "action_plugin"
  spec.version       = ActionPlugin::VERSION
  spec.authors       = ["baodongdong"]
  spec.email         = ["baodongdong@tigerjoys.com"]

  spec.summary       = %q{Plugin different kind of actions Like, Follow, Star ...}
  spec.description   = %q{Plugin different kind of actions Like, Follow, Star ...}
  spec.homepage      = "https://github.com/baodongdongCK/action_plugin"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rails", "4.2.0, ~> 5"
end

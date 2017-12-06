# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ysd_plugin_frontend_rentit_theme/version'

Gem::Specification.new do |spec|
  spec.name          = "ysd_plugin_frontend_rentit_theme"
  spec.version       = YsdPluginFrontendRentitTheme::VERSION
  spec.authors       = ["Yurak Sisa"]
  spec.email         = ["yurak.sisa.dream@gmail.com"]

  spec.summary       = %q{Yito frontend rentit theme plugin}
  spec.description   = %q{Yito frontend rentit theme plugin}
  spec.homepage      = ""

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_runtime_dependency "liquid"
end
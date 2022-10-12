lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruboty/github/version'

Gem::Specification.new do |spec|
  spec.name          = "ruboty-qiita-github"
  spec.version       = Ruboty::Github::VERSION
  spec.authors       = ["Ryo Nakamura", "Seigo Uchida"]
  spec.email         = ["r7kamura@gmail.com", "spesnova@gmail.com"]
  spec.summary       = "Manage GitHub via Ruboty."
  spec.homepage      = "https://github.com/increments/ruboty-qiita-github"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "ruboty"
  spec.add_dependency "octokit"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "webmock"
end

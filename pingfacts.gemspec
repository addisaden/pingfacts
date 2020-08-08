require_relative 'lib/pingfacts/version'

Gem::Specification.new do |spec|
  spec.name          = "pingfacts"
  spec.version       = Pingfacts::VERSION
  spec.authors       = ["Adrian E."]
  spec.email         = ["addis.aden@gmail.com"]

  spec.summary       = %q{Another Ping-Tool with additional Mac-Address information and DNS-Resolv-Name}
  spec.description   = %q{Another Ping-Tool with additional Mac-Address information and DNS-Resolv-Name. Need 'ip neigh' as command}
  spec.homepage      = "https://github.com/addisaden/pingfacts"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/addisaden/pingfacts.git"
  spec.metadata["changelog_uri"] = "https://github.com/addisaden/pingfacts/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end

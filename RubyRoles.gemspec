# frozen_string_literal: true

require_relative "lib/ruby_roles/version"

Gem::Specification.new do |spec|
  spec.name = "RubyRoles"
  spec.version = RubyRoles::VERSION
  spec.authors = ["Lee Atchison"]
  spec.email = ["lee@leeatchison.com"]

  spec.summary = "Assign roles to users, accounts, and user_accounts."
  spec.description = "Assign roles to users, accounts, user_accounts, and other models in a Ruby on Rails application."
  spec.homepage = "https://github.com/leeatchison/RubyRoles"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/leeatchison/RubyRoles"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "activesupport", ">= 6.0"
  spec.add_dependency 'activerecord', '>= 6.0'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end

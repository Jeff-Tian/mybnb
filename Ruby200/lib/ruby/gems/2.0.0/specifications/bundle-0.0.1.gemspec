# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "bundle"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Will Leinweber"]
  s.date = "2011-03-30"
  s.description = "You really mean `gem install bundler`. It's okay. I'll fix it for you this one last time..."
  s.email = "will@bitfission.com"
  s.homepage = "http://gembundler.com"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14"
  s.summary = "s/bundle/bundler"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bundler>, [">= 0"])
    else
      s.add_dependency(%q<bundler>, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>, [">= 0"])
  end
end

# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "jar_wrapper"
  s.version = "0.1.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alexander Shvets"]
  s.date = "2013-11-23"
  s.description = "Wrapper for executable java jar file."
  s.email = "alexander.shvets@gmail.com"
  s.homepage = "http://github.com/shvets/jar_wrapper"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14"
  s.summary = "Wrapper for executable java jar file (summary)."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<zip>, [">= 0"])
      s.add_development_dependency(%q<gemspec_deps_gen>, [">= 0"])
      s.add_development_dependency(%q<gemcutter>, [">= 0"])
    else
      s.add_dependency(%q<zip>, [">= 0"])
      s.add_dependency(%q<gemspec_deps_gen>, [">= 0"])
      s.add_dependency(%q<gemcutter>, [">= 0"])
    end
  else
    s.add_dependency(%q<zip>, [">= 0"])
    s.add_dependency(%q<gemspec_deps_gen>, [">= 0"])
    s.add_dependency(%q<gemcutter>, [">= 0"])
  end
end

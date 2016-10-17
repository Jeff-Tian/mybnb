# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "selenium"
  s.version = "0.2.11"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alexander Shvets"]
  s.date = "2013-11-23"
  s.description = "Gem wrapper for selenium server."
  s.email = "alexander.shvets@gmail.com"
  s.executables = ["selenium"]
  s.files = ["bin/selenium"]
  s.homepage = "http://github.com/shvets/selenium"
  s.post_install_message = "\n      -------------------------------------------------------------------------------\n\n      Please now run:\n\n        $ selenium install\n\n      NB. This will download jars that this gem needs to run from the internet.\n      It will put them into ~/.selenium/assets.\n\n      -------------------------------------------------------------------------------\n"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14"
  s.summary = "Gem wrapper for selenium server."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jar_wrapper>, [">= 0"])
      s.add_development_dependency(%q<gemspec_deps_gen>, [">= 0"])
      s.add_development_dependency(%q<gemcutter>, [">= 0"])
    else
      s.add_dependency(%q<jar_wrapper>, [">= 0"])
      s.add_dependency(%q<gemspec_deps_gen>, [">= 0"])
      s.add_dependency(%q<gemcutter>, [">= 0"])
    end
  else
    s.add_dependency(%q<jar_wrapper>, [">= 0"])
    s.add_dependency(%q<gemspec_deps_gen>, [">= 0"])
    s.add_dependency(%q<gemcutter>, [">= 0"])
  end
end

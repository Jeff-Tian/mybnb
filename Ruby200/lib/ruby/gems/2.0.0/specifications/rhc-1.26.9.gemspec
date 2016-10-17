# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rhc"
  s.version = "1.26.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Red Hat"]
  s.date = "2014-06-24"
  s.description = "The client tools for the OpenShift platform that allow for application management."
  s.email = "dev@lists.openshift.redhat.com"
  s.executables = ["rhc"]
  s.files = ["bin/rhc"]
  s.homepage = "https://github.com/openshift/rhc"
  s.post_install_message = "===========================================================================\n\nIf this is your first time installing the RHC tools, please run 'rhc setup'\n\n==========================================================================="
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14"
  s.summary = "OpenShift Client Tools"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<net-ssh>, [">= 2.0.11"])
      s.add_runtime_dependency(%q<net-scp>, [">= 1.1.2"])
      s.add_runtime_dependency(%q<net-ssh-multi>, [">= 1.2.0"])
      s.add_runtime_dependency(%q<archive-tar-minitar>, [">= 0"])
      s.add_runtime_dependency(%q<commander>, [">= 4.0"])
      s.add_runtime_dependency(%q<highline>, ["~> 1.6.11"])
      s.add_runtime_dependency(%q<httpclient>, [">= 2.2"])
      s.add_runtime_dependency(%q<open4>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0.8.7"])
      s.add_development_dependency(%q<webmock>, ["< 1.12"])
      s.add_development_dependency(%q<rspec>, ["< 2.99", ">= 2.8.0"])
      s.add_development_dependency(%q<fakefs>, [">= 0.4"])
      s.add_development_dependency(%q<thor>, [">= 0"])
      s.add_development_dependency(%q<cucumber>, [">= 0"])
      s.add_development_dependency(%q<activesupport>, ["~> 3.0"])
    else
      s.add_dependency(%q<net-ssh>, [">= 2.0.11"])
      s.add_dependency(%q<net-scp>, [">= 1.1.2"])
      s.add_dependency(%q<net-ssh-multi>, [">= 1.2.0"])
      s.add_dependency(%q<archive-tar-minitar>, [">= 0"])
      s.add_dependency(%q<commander>, [">= 4.0"])
      s.add_dependency(%q<highline>, ["~> 1.6.11"])
      s.add_dependency(%q<httpclient>, [">= 2.2"])
      s.add_dependency(%q<open4>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0.8.7"])
      s.add_dependency(%q<webmock>, ["< 1.12"])
      s.add_dependency(%q<rspec>, ["< 2.99", ">= 2.8.0"])
      s.add_dependency(%q<fakefs>, [">= 0.4"])
      s.add_dependency(%q<thor>, [">= 0"])
      s.add_dependency(%q<cucumber>, [">= 0"])
      s.add_dependency(%q<activesupport>, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<net-ssh>, [">= 2.0.11"])
    s.add_dependency(%q<net-scp>, [">= 1.1.2"])
    s.add_dependency(%q<net-ssh-multi>, [">= 1.2.0"])
    s.add_dependency(%q<archive-tar-minitar>, [">= 0"])
    s.add_dependency(%q<commander>, [">= 4.0"])
    s.add_dependency(%q<highline>, ["~> 1.6.11"])
    s.add_dependency(%q<httpclient>, [">= 2.2"])
    s.add_dependency(%q<open4>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0.8.7"])
    s.add_dependency(%q<webmock>, ["< 1.12"])
    s.add_dependency(%q<rspec>, ["< 2.99", ">= 2.8.0"])
    s.add_dependency(%q<fakefs>, [">= 0.4"])
    s.add_dependency(%q<thor>, [">= 0"])
    s.add_dependency(%q<cucumber>, [">= 0"])
    s.add_dependency(%q<activesupport>, ["~> 3.0"])
  end
end

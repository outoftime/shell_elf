# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{shell_elf}
  s.version = "0.9.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mat Brown"]
  s.date = %q{2009-04-02}
  s.default_executable = %q{shell-elf}
  s.description = %q{Daemon which executes shell commands read out of a Starling queue and optionally posts back to an HTTP server on success/failure}
  s.email = %q{mat@patch.com}
  s.executables = ["shell-elf"]
  s.files = ["Rakefile", "README.rdoc", "VERSION.yml", "bin/shell-elf", "lib/shell_elf", "lib/shell_elf/runner.rb", "lib/shell_elf/batch.rb", "lib/shell_elf/job.rb", "lib/shell_elf.rb", "spec/spec_helper.rb", "spec/services", "spec/services/http_service.rb", "spec/shell_elf_spec.rb", "tasks/gemspec.rake", "tasks/spec.rake", "script/shell-elf-listener"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/outoftime/sunspot}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Daemon which executes shell commands read out of a Starling queue and optionally posts back to an HTTP server on success/failure}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<escape>, [">= 0.0.4"])
      s.add_runtime_dependency(%q<starling-starling>, ["~> 0.9"])
      s.add_runtime_dependency(%q<daemons>, ["~> 1.0"])
      s.add_runtime_dependency(%q<choice>, [">= 0.1"])
      s.add_development_dependency(%q<rspec>, ["~> 1.1"])
      s.add_development_dependency(%q<ruby-debug>, ["~> 0.10"])
      s.add_development_dependency(%q<sinatra>, [">= 0.9"])
    else
      s.add_dependency(%q<escape>, [">= 0.0.4"])
      s.add_dependency(%q<starling-starling>, ["~> 0.9"])
      s.add_dependency(%q<daemons>, ["~> 1.0"])
      s.add_dependency(%q<choice>, [">= 0.1"])
      s.add_dependency(%q<rspec>, ["~> 1.1"])
      s.add_dependency(%q<ruby-debug>, ["~> 0.10"])
      s.add_dependency(%q<sinatra>, [">= 0.9"])
    end
  else
    s.add_dependency(%q<escape>, [">= 0.0.4"])
    s.add_dependency(%q<starling-starling>, ["~> 0.9"])
    s.add_dependency(%q<daemons>, ["~> 1.0"])
    s.add_dependency(%q<choice>, [">= 0.1"])
    s.add_dependency(%q<rspec>, ["~> 1.1"])
    s.add_dependency(%q<ruby-debug>, ["~> 0.10"])
    s.add_dependency(%q<sinatra>, [">= 0.9"])
  end
end

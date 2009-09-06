require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "simplerrd"
    gem.summary = %Q{SimpleRRD provides a simple Ruby interface for creating graphs with RRD}
    gem.description = %Q{SimpleRRD provides a simple Ruby interface for creating graphs with RRD}
    gem.email = "quigley@emerose.com"
    gem.homepage = "http://github.com/emerose/simplerrd"
    gem.authors = ["Sam Quigley"]
    gem.add_development_dependency "rspec"
    gem.add_development_dependency "yard"
    gem.files.exclude 'examples/**'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.spec_opts = ["--format", "specdoc", "--colour"]
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
  spec.spec_opts = ["--format", "specdoc", "--colour"]
end

task :spec => :check_dependencies

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end

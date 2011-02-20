require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :doc do
  require 'yard'
  YARD::Rake::YardocTask.new do |task|
    task.files   = ['HISTORY.mkd', 'LICENSE.mkd', 'lib/**/*.rb']
    task.options = [
      '--protected',
      '--output-dir', 'doc/yard',
      '--markup', 'markdown',
    ]
  end
end

namespace :tests do
  desc "Run Spork DRb server, for faster tests"
  task :spork do |task|
    sh "spork"
  end

  desc "Run a continuous testing environment"
  task :autotest do |task|
    sh "autotest"
  end
  
  desc "Run all tests"
  task :run do |task|
    Rake::Task[:spec].execute
  end
end
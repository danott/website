require_relative "./autoload.rb"
require "minitest/test_task"
require "rake/clean"

CLOBBER.include Build.target_dir

Minitest::TestTask.create do |t|
  t.test_prelude = %(require_relative "./autoload.rb")
  t.warning = false
end

desc "Build the website from #{Build.source_dir} into #{Build.target_dir}"
task :build do
  Build.write
end

desc "Run a web server hosting #{Build.target_dir}"
task :serve do
  server = WEBrick::HTTPServer.new(Port: 3000, DocumentRoot: Build.target_dir)
  trap("INT") { server.stop }
  server.start
end

task default: :build

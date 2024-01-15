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

desc "Download bookmarks from pinboard"
task :download_pinboard_bookmarks do
  PinboardBookmark.download
end

desc "Start an Irb console"
task :irb do
  binding.irb
end

desc "Temporary task to convert old posts"
task :convert_old_posts do
  old_posts =
    Dir
      .glob("_scratch/old_posts/*.md")
      .map { |path| Temp::PostMigrator.new(path) }

  if old_posts.size != old_posts.map(&:next_path).uniq.size
    fail "Naming collision!"
  end

  old_posts.each do |p|
    puts "*" * 20
    puts "prev: #{p.path}"
    puts "next: #{p.next_path}"
    puts p.next_content
    # p.write
  end
end

task default: :build

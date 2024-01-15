require "bundler/setup"

Bundler.require(:default)

require "active_support"
require "active_support/core_ext"
require "net/http"

loader = Zeitwerk::Loader.new
loader.push_dir("lib")
loader.push_dir("test")
loader.setup

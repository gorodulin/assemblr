#
# Environment-only boot script.
# Can be required from anywhere.


# Bundled gems.
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../Gemfile", __FILE__)
require "rubygems"
require "bundler/setup"

# Paths.
$: << File.expand_path("../../lib", __FILE__)


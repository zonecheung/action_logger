require File.expand_path("../lib/action_logger/version", __FILE__)

Gem::Specification.new do |s|
  s.name                      = "action_logger"
  s.version                   = ActionLogger::VERSION
  s.platform                  = Gem::Platform::RUBY
  s.authors                   = [ "John Tjanaka" ]
  s.email                     = [ "zonecheung@gmail.com" ]
  s.homepage                  = "https://github.com/zonecheung"
  s.description               = "Logs requests to the server in a database table for auditing purposes."
  s.summary                   = "action_logger-#{s.version}"

  s.rubyforge_project         = "action_logger"
  s.required_rubygems_version = "> 1.3.6"

  s.add_dependency "activesupport" , "=> 3.0.0"
  s.add_dependency "rails"         , "=> 3.0.0"
  s.add_dependency "aws-s3"

  s.files = `git ls-files`.split("\n")
  s.executables = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end


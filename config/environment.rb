# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
ActionLogger::Application.initialize!

# NOTE: This has nothing to do with the code.
# It's for trickering Rails bundle in TextMate to choose a HAML file when pressed alt-cmd-arrow_down.
# config.gem 'haml'

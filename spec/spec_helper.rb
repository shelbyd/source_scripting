$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('./', __FILE__)
require 'source_scripting'
require 'helpers/script_test_helpers'

RSpec.configure do |config|
  config.include ScriptTestHelpers
end

require 'rspec/expectations'

RSpec::Matchers.define :run_command do |expected|
  match do |actual|
    actual.has_run_commands? expected
  end
end

require 'spec_helper'

describe SourceScripting do
  it 'has a version number' do
    expect(SourceScripting::VERSION).not_to be nil
  end

  describe 'basic integration test' do
    it 'runs buy on key press' do
      file = """
        bind :t, 'buy ak47'
      """

      output = SourceScripting::Script.new(file).output
      expect(with_script(output).pressing(:t)).to run_command("buy ak47")
    end
  end
end

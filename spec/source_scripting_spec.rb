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

    it 'handles aliases' do
      script = """
        alias foo \"bar;baz;qux\"
        bind t \"foo\"
      """

      expect(with_script(script).pressing(:t)).to run_commands(['bar', 'baz', 'qux'])
    end

    it 'handles overwriting aliases' do
      script = """
        alias foo \"bar\"
        alias foo \"baz\"
        bind t \"foo\"
      """

      expect(with_script(script).pressing(:t)).to run_command('baz')
    end

    it 'handles nested aliases' do
      script = """
        alias foo \"bar\"
        alias bar \"baz\"
        bind t \"foo\"
      """

      expect(with_script(script).pressing(:t)).to run_command('baz')
    end

    it 'handles aliases that set aliases' do
      script = """
        alias foo \"alias bar baz\"
        foo
        bind t \"bar\"
      """

      expect(with_script(script).pressing(:t)).to run_command('baz')
    end

    it 'fails with nested quotes' do
      script = """
        alias foo \"alias bar \"baz\"\"
        foo
        bar
      """

      expect(with_script(script).pressing(:t)).not_to run_command('baz')
    end
  end
end

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

    it 'can have quotes in bind' do
      script = """
        bind \"t\" \"foo\"
      """

      expect(with_script(script).pressing(:t)).to run_command('foo')
    end

    it 'fails with invalid bind' do
      script = """
        bind \"t\" \"run \"fake\"\"
      """

      expect { with_script(script) }.to raise_error "Invalid script: 'bind \"t\" \"run \"fake\"\"'"
    end

    it 'alias can have quotes in name' do
      script = """
        alias \"foo\" \"run\"
        foo
      """

      expect(with_script(script).pressing(:t)).to run_command('run')
    end

    it 'fails with invalid alias' do
      script = """
        alias foo \"run \"fake\"\"
      """

      expect { with_script(script) }.to raise_error "Invalid script: 'alias foo \"run \"fake\"\"'"
    end

    it 'does not require quotes in binds' do
      script = """
        bind t foo
      """

      expect(with_script(script).pressing(:t)).to run_command('foo')
    end
  end
end

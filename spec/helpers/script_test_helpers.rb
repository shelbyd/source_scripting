module ScriptTestHelpers
  def with_script(script)
    ScriptTest.new(script)
  end

  class ScriptTest < Struct.new(:script)
    def initialize(script)
      super(script)
      self.commands_run += execute(script)
    end

    def pressing(key)
      self.commands_run += commands_for_key(key)
      self
    end

    def has_run_command?(command)
      commands_run.include? command
    end

    def has_run_commands?(commands)
      commands.all? { |c| has_run_command? c }
    end

    def commands_run
      @commands_run ||= []
    end

    private

    def commands_run=(commands)
      @commands_run = commands
    end

    def commands_for_key(key)
      execute bindings[key]
    end

    def bindings
      @bindings ||= {}
    end

    def aliases
      @aliases ||= {}
    end

    def execute(subscript)
      return [] if subscript.nil?
      subscript = subscript.strip

      if subscript.include? "\n"
        return subscript.split("\n").map do |line|
          execute line
        end.flatten
      end

      if subscript.start_with? "bind"
        match = subscript.match /bind ([^\s]+) "([^"]*)"$/
        raise "Invalid script: '#{subscript}'" if match.nil?
        key = match[1]
        key_match = key.match(/"(.*)"/)
        unless key_match.nil?
          key = key_match[1]
        end
        bindings[key.to_sym] = match[2]
        return []
      end

      if subscript.start_with? "alias"
        match = subscript.match /alias ([^\s]+) "([^"]*)"$/
        if match.nil?
          match = subscript.match /alias ([^\s]+) ([^\s]+)$/
        end
        raise "Invalid script: '#{subscript}'" if match.nil?

        name = match[1]
        name_match = name.match(/"(.*)"/)
        unless name_match.nil?
          name = name_match[1]
        end

        aliases[name] = match[2]
        return []
      end

      subscript.split(';').map do |command|
        if aliases[command].nil?
          command
        else
          execute aliases[command]
        end
      end.flatten
    end
  end
end

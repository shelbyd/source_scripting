module ScriptTestHelpers
  def with_script(script)
    ScriptTest.new(script)
  end

  class ScriptTest < Struct.new(:script)
    def initialize(script)
      super(script)
      execute(script)
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
        match = subscript.match /bind (.+) "(.+)"/
        key = match[1].to_sym
        bindings[key] = match[2]
        return []
      end

      if subscript.start_with? "alias"
        match = subscript.match /alias ([^\s]+) "(.*)"/
        if match.nil?
          match = subscript.match /alias ([^\s]+) ([^\s]+)/
        end
        key = match[1]
        aliases[key] = match[2]
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

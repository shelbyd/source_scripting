require "source_scripting/version"

module SourceScripting
  def self.exec(commands_file, output_file)
    file.read(commands_file)
  end

  class Script < Struct.new(:file_contents)
    def output
      instance_eval file_contents
      output_script.join "\n"
    end

    def method_missing(method_name, *args)
      args = args.map { |a| a.is_a?(String) ? "\"#{a}\"" : a }
      self.output_script << "#{method_name} #{args.join(' ')}"
    end

    def output_script
      @output_script ||= []
    end
  end
end

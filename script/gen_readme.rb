#!/usr/bin/env ruby

class Gen
  def initialize
    Dir.chdir(File.join(__dir__, '..'))
    @tpl = IO.binread('README.tpl.md')
  end

  def work
    replace('SHELL_OUTPUT_OF') do |cmd|
      '$ ' + cmd + "\n" + `PATH="$PWD/bin:$PATH" #{cmd}`.lines.map do |c|
        next "#\n" if c.strip.empty?
        '# ' + c
      end.join
    end
    IO.binwrite('README.md', @tpl)
  end

  private

  def replace(prefix)
    @tpl.gsub!(/#{prefix}\(.*\)/) do |s|
      yield(s[(prefix.size + 1)...-1])
    end
  end
end

Gen.new.work

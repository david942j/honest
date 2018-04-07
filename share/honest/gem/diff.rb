require 'set'
require 'yaml'

class HonestError < StandardError
end

class Diff
  attr_reader :source_path, :pkg_path

  def initialize(source_path, pkg_path)
    @source_path = source_path
    @pkg_path = pkg_path
    load_spec
  end

  def run
    check_metadata_files
  end

  private

  def load_spec
    @spec = YAML.safe_load(File.read(File.join(pkg_path, 'metadata')),
                           [Gem::Dependency, Gem::Requirement,
                            Gem::Specification, Gem::Version,
                            Symbol, Time], [], true)
    unhonest('Invalid metadata.') unless @spec.instance_of?(Gem::Specification)
  end

  def check_metadata_files
    Dir.chdir(File.join(@pkg_path, 'data'))
    presented = Dir.glob('**/*').select { |f| File.file?(f) }
    additional = presented - @spec.files
    missing = @spec.files - presented
    unless additional.empty?
      unhonest("Additional files in package: #{additional.join(', ')}.")
    end
    unless missing.empty?
      unhonest("Missing files in package: #{missing.join(', ')}.")
    end
  end

  def unhonest(msg)
    raise HonestError, msg
  end
end

exit 1 if ARGV.size != 2
begin
  Diff.new(*ARGV).run
rescue HonestError => e
  # TODO: gen reports
  warn('Unhonest! ' + e.message)
  exit 1
end

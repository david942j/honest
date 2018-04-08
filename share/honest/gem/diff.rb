require 'digest'
require 'set'
require 'yaml'

class HonestError < StandardError
end

class Diff
  def initialize(source_path, pkg_path)
    @source_path = source_path
    @pkg_path = pkg_path
    load_spec
  end

  def run
    check_metadata_files
    check_files_presented
    check_hash
  end

  private

  def load_spec
    @spec = YAML.safe_load(File.read(File.join(@pkg_path, 'metadata')),
                           [Gem::Dependency, Gem::Requirement,
                            Gem::Specification, Gem::Version,
                            Symbol, Time], [], true)
    unhonest('Invalid metadata.') unless @spec.instance_of?(Gem::Specification)
  end

  def check_metadata_files
    Dir.chdir(File.join(@pkg_path, 'data')) do
      presented = Dir.glob('**/*').select { |f| File.file?(f) }
      additional = presented - @spec.files
      missing = @spec.files - presented
      unhonest("Additional files in package: #{additional.join(', ')}.") if additional.any?
      unhonest("Missing files in package: #{missing.join(', ')}.") if missing.any?
    end
  end

  # Check if files listed in metadata are present in source code.
  def check_files_presented
    missing = @spec.files.reject do |f|
      File.file?(File.join(@source_path, f))
    end
    unhonest("Files in package but not in source: #{missing.join(', ')}.") if missing.any?
  end

  def check_hash
    # metadata has been checked
    different = []
    @spec.files.each do |f|
      source = hash_of(File.join(@source_path, f))
      pkg = hash_of(File.join(@pkg_path, 'data', f))
      different << f if source != pkg
    end
    # TODO: gen reports
    unhonest("Files different: #{different.join(', ')}.") if different.any?
  end

  def hash_of(file)
    # XXX: replace "\r\n" with "\n" ?
    Digest::SHA256.hexdigest(IO.binread(file))
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

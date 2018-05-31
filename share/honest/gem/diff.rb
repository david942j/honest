require 'digest'
require 'yaml'

class HonestError < StandardError
end

# Three steps:
# 1. Check files in gem matches metadata specified
# 2. Check all files in pkg appear in source
# 3. Check all files in gem are same as in source
class Diff
  def initialize(source_path, pkg_path)
    @source_path = source_path
    @pkg_path = pkg_path
    load_spec
  end

  def run
    check_metadata_files
    check_files_present
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
      present = Dir.glob('**/*', File::FNM_DOTMATCH).select { |f| File.file?(f) }
      extra = present - @spec.files
      missing = @spec.files - present
      unhonest('Extra files in package: %s.', extra) if extra.any?
      unhonest('Missing files in package: %s.', missing) if missing.any?
    end
  end

  # Check if files listed in metadata are present in source code.
  def check_files_present
    missing = @spec.files.reject do |f|
      File.file?(File.join(@source_path, f))
    end
    unhonest('Files in package but not in source: %s.', missing) if missing.any?
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
    exit 1 if different.any?
  end

  def hash_of(file)
    # XXX: replace "\r\n" with "\n" ?
    Digest::SHA256.hexdigest(IO.binread(file))
  end

  def unhonest(msg, ary = [])
    raise HonestError, format(msg, ary.map(&:inspect).join(', '))
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

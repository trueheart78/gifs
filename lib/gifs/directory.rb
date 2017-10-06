module Gifs
  class Directory
    def initialize(criteria: [])
      @criteria = criteria
    end

    def to_s
      "#{humanize(gif_count)} gifs in #{humanize(dir_count)} directories"
    end

    def gif_count
      gifs.size
    end

    def dir_count
      dirs.size
    end

    def gifs
      return [] if gif_paths.empty?
      @gifs ||= Dir[*gif_paths].reject { |p| File.directory? p }
    end

    def dirs
      return [] if dir_paths.empty?
      return criteria_dirs if criteria.any?
      @dirs ||= Dir[*dir_paths].select { |p| File.directory? p }
    end

    private

    attr_reader :criteria

    def gif_paths
      @gif_paths ||= search_paths('*.gif')
    end

    def dir_paths
      @dir_paths ||= search_paths('*')
    end

    def search_paths(file_match)
      glob_patterns.map { |p| File.join(dir, p, file_match) }
    end

    def glob_patterns
      return ['**'] if criteria.empty?
      @glob_patterns ||= valid_criteria.map { |c| "**/*#{c}*/**" }
    end

    def criteria_dirs
      return [] if valid_criteria.empty?
      @criteria_dirs ||= unique_criteria_dirs
    end

    def valid_criteria
      criteria.select { |c| File.directory?(File.join(dir, c)) }
    end

    def unique_criteria_dirs
      gifs.map { |v| v.gsub(dir + '/', '')
        .split('/')
        .reject { |v| v.end_with? '.gif' } }
        .flatten
        .uniq
        .map { |v| File.join(dir, v) }
    end

    def dir
      raise "No environment var provided for #{Gifs::ENV_DIR_KEY}" unless ENV[Gifs::ENV_DIR_KEY]
      ENV[Gifs::ENV_DIR_KEY]
    end

    def humanize(number)
      number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\1,').reverse
    end
  end
end

# frozen_string_literal: true

module Gifs
  class Directory
    def initialize(criteria: [])
      @criteria = criteria
    end

    def to_s
      "#{humanize(gifs.size)} gifs in #{humanize(dirs.size)} directories"
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

    def base_criteria_dirs
      gifs.map do |path|
        path.gsub(dir + '/', '')
            .split('/')
            .reject { |file| file.end_with? '.gif' }
      end
    end

    def unique_criteria_dirs
      base_criteria_dirs.flatten.uniq.map { |file| File.join(dir, file) }
    end

    def dir
      Gifs.gifs_path
    end

    def humanize(number)
      number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\1,').reverse
    end
  end
end

module Gifs
  class Directory
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
      @gifs ||= Dir[File.join(dir, '**', '*.gif')].reject { |p| File.directory? p }
    end

    def dirs
      @dirs ||= Dir[File.join(dir, '**', '*')].select { |p| File.directory? p }
    end

    private

    def dir
      raise "No environment var provided for #{Gifs::ENV_DIR_KEY}" unless ENV[Gifs::ENV_DIR_KEY]
      ENV[Gifs::ENV_DIR_KEY]
    end

    def humanize(number)
      number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\1,').reverse
    end
  end
end

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
      return File.expand_path ENV['gif_dir'] if ENV['gif_dir']
      raise 'No gif_dir environment var provided'
    end

    def humanize(number)
      number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\1,').reverse
    end
  end
end

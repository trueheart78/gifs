module Gifs
  class Entry
    delegate :url, to: :link
    delegate :to_md, to: :link
    delegate :dropbox_link, to: :gif

    def initialize(relative_path)
      @relative_path = relative_path
    end

    def create_link
      return unless Gifs.gif_exists? relative_path
      load_record
      true
    end

    def to_s
      return unless link
      [
        '----------',
        "gif: #{link.base_name}",
        "size: #{link.size}",
        "url: #{link.url}",
        "markdown: #{link.to_md}",
        '----------'
      ].join "\n"
    end

    private

    attr_reader :relative_path, :dropbox_link, :link

    def gif
      @gif ||= Gifs::Models::Gif.where(base_name: base_name)
                                .first_or_create(dir_name: dir_name, size: size)
    end

    def base_name
      File.basename relative_path
    end

    def dir_name
      File.dirname relative_path
    end

    def size
      File.size Gifs.gif_path(relative_path)
    end

    def load_record
      unless dropbox_link
      end

      unless @link
        @link = Gifs::Dropbox.new.public_link file_path: File.join('/gifs', relative_path)
        # TODO: create missing dropbox_link record
      end
    end
  end
end

module Gifs
  class Link
    def initialize(hash)
      @hash = hash
    end

    def id
      hash[:id].split(':').second
    end

    def url
      [Dropbox::PUBLIC_HOST, path].compact.join
    end

    def to_s
      "#{id}: #{url}"
    end

    def to_md
      "![#{basename}](#{url})"
    end

    private

    attr_reader :hash

    def basename
      File.basename hash[:path_lower]
    end

    def path
      URI.parse(hash[:url]).path
    end
  end
end

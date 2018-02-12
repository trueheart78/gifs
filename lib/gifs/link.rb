# frozen_string_literal: true

module Gifs
  class Link
    def initialize(hash)
      @hash = hash
    end

    def id
      hash[:id].split(':').second
    end

    def url
      URI.join(Dropbox::PUBLIC_HOST, File.join(remote_path, CGI.escape(basename))).to_s
    end

    def md
      "![#{basename}](#{url})"
    end

    def to_s
      "#{id}: #{url}"
    end

    def basename
      File.basename hash[:path_lower]
    end

    def directory
      File.dirname(hash[:path_lower]).gsub('/gifs', '')
    end

    def size
      hash[:size]
    end

    def remote_path
      File.dirname URI.parse(hash[:url]).path
    end

    private

    attr_reader :hash
  end
end

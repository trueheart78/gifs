# frozen_string_literal: true

module Gifs
  class Entry
    delegate :url, to: :link
    delegate :md, to: :link
    delegate :shared_link, to: :gif

    def initialize(relative_path)
      @relative_path = relative_path
      @link_created = false
    end

    def self.load_by_id(id)
      new(Gifs::Models::Gif.find_by_id(id).relative_path).tap(&:create_link)
    end

    def create_link
      return true if link_created?
      return unless Gifs.gif_exists? relative_path
      load_record
      @link_created = true
    end

    def to_s
      create_link
      return unless link
      "[#{gif.id}] [#{gif.tags}] #{link.basename} (#{human_size}) " \
        "[used: #{link.count}]".colorize(color)
    end

    private

    attr_reader :relative_path, :link

    def color
      return Theme.new_entry if link.count == 1
      Theme.existing_entry
    end

    def human_size
      link_size = link.size
      types = %w[B KB MB GB]
      while link_size >= 1_000
        types.shift
        link_size /= 1_000.00
      end
      round_to = link.size < 1_000_000 ? 0 : 1
      "#{link_size.round(round_to)} #{types.first.upcase}"
    end

    def link_created?
      @link_created
    end

    def gif
      @gif ||= Models::Gif.includes(:shared_link)
                          .where(basename: basename, directory: directory, size: size)
                          .first
    end

    def basename
      File.basename relative_path
    end

    def directory
      File.dirname relative_path
    end

    def size
      File.size Gifs.gif_path(relative_path)
    end

    def dropbox_link
      Gifs::Dropbox.new.public_link file_path: relative_path
    end

    def load_record
      @gif = Gifs::Models::Gif.import dropbox_link unless gif && shared_link
      shared_link.increment! :count
      @link = shared_link
    end
  end
end

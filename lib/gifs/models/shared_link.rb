# frozen_string_literal: true

module Gifs
  module Models
    class SharedLink < ActiveRecord::Base
      belongs_to :gif

      delegate :basename, to: :gif
      delegate :size, to: :gif

      def url
        File.join Gifs::Dropbox::PUBLIC_HOST, File.join(remote_path, CGI.escape(basename))
      end

      def md
        "![#{basename}](#{url})"
      end
    end
  end
end

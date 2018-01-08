module Gifs
  module Models
    class DropboxLink < ActiveRecord::Base
      belongs_to :gif

      delegate :base_name, to: :gif

      def url
        URI.join(Gifs::Dropbox::PUBLIC_HOST, remote_path).to_s
      end

      def to_md
        "![#{base_name}](#{url})"
      end
    end
  end
end

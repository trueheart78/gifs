module Gifs
  module Models
    class DropboxLink < ActiveRecord::Base
      belongs_to :gif

      def url
        URI.join(Gifs::Dropbox::PUBLIC_HOST, remote_path).to_s
      end
    end
  end
end

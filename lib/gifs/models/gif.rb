module Gifs
  module Models
    class Gif < ActiveRecord::Base
      has_one :dropbox_link

      delegate :url, to: :dropbox_link
      delegate :to_md, to: :dropbox_link
    end
  end
end

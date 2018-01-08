module Gifs
  module Models
    class Gif < ActiveRecord::Base
      has_one :dropbox_link
    end
  end
end

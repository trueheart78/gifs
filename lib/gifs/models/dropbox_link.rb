module Gifs
  module Models
    class DropboxLink < ActiveRecord::Base
      belongs_to :gif
    end
  end
end

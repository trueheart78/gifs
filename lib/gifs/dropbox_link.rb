module Gifs
  class DropboxLink < ActiveRecord::Base
    belongs_to :gif
  end
end

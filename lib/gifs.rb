require 'active_record'
require 'sqlite3'
require 'clipboard'
require 'gifs/version'
require 'gifs/config'
require 'gifs/directory'
require 'gifs/gif'
require 'gifs/link'
require 'gifs/dropbox_link'
require 'gifs/dropbox'
require 'gifs/listener'

module Gifs
  class << self
    def dropbox_path
      Gifs::Config.instance.dropbox_path
    end

    def gifs_path(file = nil)
      File.join [dropbox_path, 'gifs', file].compact
    end
    alias gif_path gifs_path

    def gif_exists?(file)
      File.exist? gifs_path(file)
    end

    def db_connect
      return true if ActiveRecord::Base.connected?

      ActiveRecord::Base.establish_connection(
        adapter:  'sqlite3',
        database: db_path
      )
      load 'schema.rb'
    end

    def db_path
      File.join(gifs_path, 'ruby_gif_manager.db')
    end
  end
end

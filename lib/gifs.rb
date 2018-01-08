require 'active_record'
require 'sqlite3'
require 'clipboard'
require 'gifs/version'
require 'gifs/config'
require 'gifs/directory'
require 'gifs/models/gif'
require 'gifs/models/dropbox_link'
require 'gifs/link'
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

    def db_disconnect
      ActiveRecord::Base.remove_connection
    end

    def db_path
      Dir.mkdir data_path unless Dir.exist? data_path
      File.join data_path, db_name
    end

    private

    def data_path
      File.join gifs_path, ".#{self.name.downcase}"
    end

    def db_name
      "#{self.name.downcase}.sqlite3.db"
    end
  end
end

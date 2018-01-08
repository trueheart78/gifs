module Gifs
  class Config
    include Singleton

    ConfigNotFound = Class.new StandardError
    MissingConfigValues = Class.new StandardError

    CONFIG_FILE = File.expand_path('~/.gifs_config').freeze
    DROPBOX_PATH = 'DROPBOX_PATH'.freeze
    DROPBOX_TOKEN = 'DROPBOX_TOKEN'.freeze

    def initialize
      return if required_keys? ENV
      load_yaml
      validate_yaml
    end

    def dropbox_path
      return ENV[DROPBOX_PATH] if ENV.key? DROPBOX_PATH
      @dropbox_path ||= File.expand_path(data[DROPBOX_PATH])
    end

    def dropbox_token
      return ENV[DROPBOX_TOKEN] if ENV.key? DROPBOX_TOKEN
      @dropbox_token ||= data[DROPBOX_TOKEN]
    end

    private

    attr_reader :data

    def load_yaml
      require 'yaml'
      @data = YAML.load_file CONFIG_FILE if File.exist? CONFIG_FILE
      raise ConfigNotFound, "Unable to find #{CONFIG_FILE}" unless File.exist? CONFIG_FILE
      missing_config_error unless data
    end

    def validate_yaml
      missing_config_error unless required_keys? data
    end

    def missing_config_error
      raise MissingConfigValues,
            "Config does not have required keys: #{required_config_keys.join(', ')}"
    end

    def required_keys?(hash)
      missing_keys = required_config_keys
      required_config_keys.each do |key|
        missing_keys.delete key if hash.key? key
      end
      missing_keys.empty?
    end

    def required_config_keys
      [DROPBOX_PATH, DROPBOX_TOKEN]
    end
  end
end

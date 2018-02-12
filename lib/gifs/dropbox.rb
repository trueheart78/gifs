# frozen_string_literal: true

require 'faraday'
require 'typhoeus'
require 'typhoeus/adapters/faraday'
require 'active_support/all'
require 'json'

module Gifs
  class Dropbox
    Error = Class.new StandardError

    PUBLIC_HOST = 'https://dl.dropboxusercontent.com'

    def public_link(file_path:, directory: '/gifs')
      @file_path = File.join(directory, file_path)
      check_existing_shared_link
      create_shared_link unless shared_link.present?
      shared_link
    end

    private

    attr_reader :file_path, :json, :shared_link, :request

    def validate_file_path
      @file_path = "/#{file_path}" unless file_path.start_with? '/'
    end

    def creation_data
      data.merge settings: { requested_visibility: 'public' }
    end

    def token
      Gifs::Config.instance.dropbox_token
    end

    def connection
      @conn ||= Faraday.new(url: url) do |conn|
        conn.headers['Authorization'] = "Bearer #{token}"
        conn.headers['Content-Type'] = 'application/json'

        conn.adapter :typhoeus
      end
    end

    def check_existing_shared_link
      make_request existing_path, data
    end

    def create_shared_link
      make_request creation_path, creation_data
    end

    def make_request(path, payload)
      @request = connection.post path, payload.to_json
      return handle_response if request.success?
      raise_error
    end

    def raise_error
      raise Error, error_message unless request.success?
    end

    def error_message
      return request.body if request.body.present?
      request.status
    end

    def handle_response
      @json = JSON.parse(request.body).deep_symbolize_keys
      @shared_link = extract_link json
    end

    def extract_link(json)
      return if json[:links]&.empty?
      return Link.new(json[:links].first) if json[:links]&.any?
      Link.new json
    end

    def data
      {
        path: file_path
      }
    end

    def existing_path
      'sharing/list_shared_links'
    end

    def creation_path
      'sharing/create_shared_link_with_settings'
    end

    def url
      'https://api.dropboxapi.com/2'
    end
  end
end

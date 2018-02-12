# frozen_string_literal: true

module Gifs
  module Models
    class Gif < ActiveRecord::Base
      has_one :shared_link

      delegate :url, to: :shared_link
      delegate :md, to: :shared_link
      delegate :count, to: :shared_link

      def relative_path
        File.join directory, basename
      end

      def tags
        directory.split('/').reject(&:empty?).join(', ')
      end

      def self.import(link)
        create(basename: link.basename, directory: link.directory, size: link.size).tap do |gif|
          shared_link = SharedLink.find_by_id link.id
          gif.shared_link = if shared_link
                              shared_link
                            else
                              SharedLink.create id: link.id, remote_path: link.remote_path
                            end
          gif.update_attribute :shared_link_id, link.id
        end
      end
    end
  end
end

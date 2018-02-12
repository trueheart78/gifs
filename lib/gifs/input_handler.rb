# frozen_string_literal: true

# rubocop:disable ClassLength
module Gifs
  class InputHandler
    def initialize(input:, mode:)
      @input = input
      @mode = mode
      @continue = true
      @processed = false
      @mode_change = false
      @entries = []
    end

    def process
      return if processed?
      clean_input
      analyze_input
      mark_as_processed
    end

    def continue?
      process unless processed?
      @continue
    end

    def mode_change?
      process unless processed?
      @mode_change
    end

    def mode
      process unless processed?
      @mode
    end

    def entry
      process unless processed?
      @entries.last
    end

    def entries
      process unless processed?
      @entries
    end

    private

    attr_reader :continue

    def input
      @input.strip
    end

    def analyze_input
      if input.in? exit_phrases
        @continue = false
      elsif input.in? mode_phrases
        detect_mode
      elsif integer?
        find_entry
      else
        create_entries
      end
    end

    def find_entry
      @entries = [Entry.load_by_id(input.to_i)]
    end

    def create_entries
      @entries = split_input.map do |relative_path|
        create_entry relative_path
      end
    end

    def create_entry(relative_path)
      return unless Gifs.gif_exists? relative_path
      Entry.new(relative_path).tap(&:create_link)
    end

    def mark_as_processed
      @processed = true
    end

    def processed?
      @processed
    end

    def detect_mode
      if url_mode?
        @mode_change = true
        @mode = :url
      elsif md_mode?
        @mode_change = true
        @mode = :md
      end
    end

    def split_input
      @split_input ||= input.gsub(Gifs.gifs_path, '')
                            .split('.gif')
                            .map(&:strip)
                            .map { |s| s + '.gif' }
    end

    def clean_input
      @input = if apostrophes? input
                 remove_apostrophes
               elsif double_quotes? input
                 remove_double_quotes
               else
                 input.delete('\\').strip
               end
    end

    def apostrophes?(input)
      input.starts_with?("'") && input.ends_with?("'")
    end

    def remove_apostrophes
      input[1...-1].gsub(".gif' '", '.gif ').strip
    end

    def double_quotes?(input)
      input.starts_with?('"') && input.ends_with?('"')
    end

    def remove_double_quotes
      input[1...-1].gsub('.gif" "', '.gif ').strip
    end

    def multiple_entries?(input)
      return true if input.scan('.gif').size > 1
      false
    end

    def integer?
      input.to_i.to_s == input
    end

    def url_mode?
      input.in? url_phrases
    end

    def md_mode?
      input.in? md_phrases
    end

    def url_phrases
      %w[url u ur]
    end

    def md_phrases
      %w[markdown md m mark]
    end

    def mode_phrases
      [md_phrases, url_phrases].flatten
    end

    def exit_phrases
      %w[exit quit q e :q :e stop halt]
    end
  end
end
# rubocop:enable ClassLength

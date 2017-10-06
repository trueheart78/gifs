module Gifs
  class Listener
    class << self
      def start
        input = clean_input prompt_input
        kick_out = false
        parse(input).each do |entry|
          kick_out = true if exit_code? entry
          break if kick_out
          handle_input "#{entry}.gif" unless exit_code? entry
        end
        start unless kick_out
        exit_gracefully if kick_out
      end

      private

      def handle_input(entry)
        if Gifs.gif_exists? entry
          link = Gifs::Dropbox.new.public_link file_path: File.join('/gifs', entry)
          Clipboard.copy link.url
          output entry, link
        else
          puts 'error: file does not exist' + " [#{entry}]"
        end
      rescue Gifs::Dropbox::Error => e
        puts "dropbox error: #{e.message}"
      end

      def output(entry, link)
        puts '**********'
        puts "gif: #{entry}"
        puts "url: #{link.url}"
        puts "markdown: #{link.to_md}"
        puts '**********'
      end

      def exit_gracefully
        puts 'Exiting.'
      end

      def prompt_input
        puts 'Waiting for input...'
        gets.chomp
      end

      def clean_input(input)
        input.delete('\\').strip
      end

      def multiple_entries?(input)
        return true if input.scan('.gif').size > 1
        false
      end

      def parse(input)
        input.gsub(Gifs.gifs_path, '').split('.gif').map(&:strip)
      end

      def exit_code?(input)
        return true if exit_phrases.include? input.downcase
        false
      end

      def exit_phrases
        %w[exit quit q e :q :e]
      end
    end
  end
end

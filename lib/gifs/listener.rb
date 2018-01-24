module Gifs
  class Listener
    class << self
      def start
        input = clean_input prompt_input
        kick_out = false
        parse(input).each do |entry|
          kick_out = true if exit_code? entry
          break if kick_out
          butts = Entry.new "#{entry}.gif"
          if butts.create_link
            puts butts
            Clipboard.copy butts.url
          else
            puts "unable to locate file [#{entry}.gif]"
          end
        end
        start unless kick_out
        exit_gracefully if kick_out
      rescue Gifs::Dropbox::Error => e
        puts "dropbox error: #{e.message}"
      end

      private

      def exit_gracefully
        puts 'Exiting.'
      end

      def prompt_input
        puts 'Waiting for input...'
        gets.chomp
      end

      def clean_input(input)
        input.strip!
        if apostrophes? input
          input[1...-1].gsub(".gif' '", '.gif ').strip
        elsif double_quotes? input
          input[1...-1].gsub('.gif" "', '.gif ').strip
        else
          input.delete('\\').strip
        end
      end

      def apostrophes?(input)
        input.starts_with?("'") && input.ends_with?("'")
      end

      def double_quotes?(input)
        input.starts_with?('"') && input.ends_with?('"')
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

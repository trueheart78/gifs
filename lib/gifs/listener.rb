module Gifs
  class Listener
		def initialize(mode=:url)
			@mode = mode
		end

		def start
			Gifs::db_connect
      welcome_user unless input_handler
			input_handler(prompt_input).process
			if input_handler.continue?
				if input_handler.mode_change?
					@mode = input_handler.mode
          display_mode_shift
        else
          input_handler.entries.each do |entry|
            puts entry
          end
          @recent_entry = input_handler.entry
        end
        if recent_entry
          Clipboard.copy recent_entry.send(mode)
          display_copied_data if input_handler.mode_change?
        end
      else
        exit_gracefully
        return
      end
      start
    ensure
      Gifs::db_disconnect
    end

    private

    attr_reader :mode, :recent_entry

    def display_mode_shift
      puts "♪ mode shifted to #{mode} ♪".colorize(Theme.mode_shift)
    end

    def display_copied_data
      puts "#{recent_entry.send(mode)}".colorize(Theme.clipboard)
    end

    def reset_input_handler
      @input_handler = nil
    end

    def input_handler(input=nil)
      if input
        @input_handler = InputHandler.new(input: input, mode: mode)
      end
      @input_handler
    end

    def prompt_input
      print 'Waiting for input...'.colorize(Theme.prompt)
      puts "               ♪ #{mode} ♪".colorize(Theme.mode_shift)
      gets.chomp
    end

    def welcome_user
      print '♥'.colorize(Theme.heart)
      print ' Welcome '.colorize(Theme.welcome)
      puts '♥'.colorize(Theme.heart)
    end

    def exit_gracefully
      print '♥'.colorize(Theme.heart)
      print ' Goodbye '.colorize(Theme.goodbye)
      puts '♥'.colorize(Theme.heart)
    end
  end
end

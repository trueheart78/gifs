# frozen_string_literal: true

module Gifs
  class Theme
    class << self
      def prompt
        :light_magenta
      end

      def new_entry
        :light_yellow
      end

      def existing_entry
        :light_white
      end

      def mode_shift
        :light_cyan
      end

      def clipboard
        :cyan
      end

      def goodbye
        :light_cyan
      end

      def welcome
        :light_cyan
      end

      def heart
        :red
      end
    end
  end
end

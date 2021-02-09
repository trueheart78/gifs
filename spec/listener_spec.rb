# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gifs::Listener do
  describe '#start' do
  end

  def provide_input(input)
    allow(STDIN).to receive(:gets).and_return input
  end
end

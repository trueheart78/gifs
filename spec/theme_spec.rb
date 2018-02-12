# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gifs::Theme do
  subject { described_class }

  it { is_expected.to respond_to :prompt }
  it { is_expected.to respond_to :new_entry }
  it { is_expected.to respond_to :existing_entry }
  it { is_expected.to respond_to :mode_shift }
  it { is_expected.to respond_to :clipboard }
  it { is_expected.to respond_to :goodbye }
  it { is_expected.to respond_to :welcome }
  it { is_expected.to respond_to :heart }

  it 'returns the expected prompt' do
    expect(subject.prompt).to eq :light_magenta
  end

  it 'returns the expected new_entry' do
    expect(subject.new_entry).to eq :light_yellow
  end

  it 'returns the expected existing_entry' do
    expect(subject.existing_entry).to eq :light_white
  end

  it 'returns the expected mode_shift' do
    expect(subject.mode_shift).to eq :light_cyan
  end

  it 'returns the expected clipboard' do
    expect(subject.clipboard).to eq :cyan
  end

  it 'returns the expected goodbye' do
    expect(subject.goodbye).to eq :light_cyan
  end

  it 'returns the expected welcome' do
    expect(subject.welcome).to eq :light_cyan
  end

  it 'returns the expected heart' do
    expect(subject.heart).to eq :red
  end
end

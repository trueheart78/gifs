require 'spec_helper'
require 'gifs/directory'

RSpec.describe Gifs::Directory do
  subject { described_class.new }

  describe '#to_s' do
    it 'returns the expected output' do
      expect(subject.to_s).to eq output
    end

    let(:output) { "#{subject.gif_count} gifs in #{subject.dir_count} directories" }
  end

  describe '#gif_count' do
    it 'returns the expected count' do
      expect(subject.gif_count).to eq count
    end

    let(:count) { 2 }
  end

  describe '#dir_count' do
    it 'returns the expected count' do
      expect(subject.dir_count).to eq count
    end

    let(:count) { 2 }

    context 'when no ENV gif_dir is provided' do
      before do
        @storage = ENV.delete 'gif_dir'
      end

      it 'explodes with a Runtime Error' do
        expect{ subject.dirs }.to raise_error RuntimeError
      end

      after do
        ENV['gif_dir'] = @storage
      end
    end
  end
end

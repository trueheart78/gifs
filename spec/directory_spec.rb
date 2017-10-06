require 'spec_helper'
require 'gifs/directory'

RSpec.describe Gifs::Directory do
  subject { described_class.new }

  describe '#to_s' do
    it 'returns the expected output' do
      expect(subject.to_s).to eq output
    end

    let(:output) { "#{subject.gifs.size} gifs in #{subject.dirs.size} directories" }
  end

  describe '#gifs' do
    it 'returns the expected array' do
      expect(subject.gifs).to match_array array
    end

    let(:array) do
      [
        gif_path('thumbs up/sample.gif'),
        gif_path('thumbs down/sample.gif')
      ]
    end
  end

  describe '#dirs' do
    it 'returns the expected array' do
      expect(subject.dirs).to match_array array
    end

    let(:array) do
      [
        gif_path('thumbs up'),
        gif_path('thumbs down')
      ]
    end

    context 'when no ENV gif_dir is provided' do
      before do
        @storage = ENV.delete Gifs::ENV_DIR_KEY
      end

      it 'explodes with a Runtime Error' do
        expect { subject.dirs }.to raise_error RuntimeError
      end

      after do
        ENV[Gifs::ENV_DIR_KEY] = @storage
      end
    end
  end
end

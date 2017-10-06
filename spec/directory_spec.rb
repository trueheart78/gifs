require 'spec_helper'
require 'gifs/directory'

RSpec.describe Gifs::Directory do
  subject { described_class.new criteria: criteria }

  describe '#to_s' do
    it 'returns the expected output' do
      expect(subject.to_s).to eq output
    end

    let(:output) { "#{subject.gifs.size} gifs in #{subject.dirs.size} directories" }
  end

  describe '#gifs' do
    context 'without search criteria' do
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

    context 'with matching search criteria' do
      it 'returns the expected array' do
        expect(subject.gifs).to match_array array
      end

      let(:criteria) { ['thumbs up'] }
      let(:array) do
        [
          gif_path('thumbs up/sample.gif')
        ]
      end
    end

    context 'with matching search criteria that is empty' do
      it 'returns the expected array' do
        expect(subject.gifs).to match_array array
      end

      let(:criteria) { ['empty'] }
      let(:array) { [] }
    end

    context 'with unmatching search criteria' do
      it 'returns the expected array' do
        expect(subject.gifs).to be_empty
      end

      let(:criteria) { ['dfalkshfdlkjsahfsalkj'] }
    end
  end

  describe '#dirs' do
    it 'returns the expected array' do
      expect(subject.dirs).to match_array array
    end

    let(:array) do
      [
        gif_path('empty'),
        gif_path('thumbs up'),
        gif_path('thumbs down')
      ]
    end
  end

  let(:criteria) { [] }
end

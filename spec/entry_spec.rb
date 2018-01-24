require 'spec_helper'

RSpec.describe Gifs::Entry do
  include_context 'database'

  describe '#create_link' do
    before do
      allow(Gifs).to receive(:gif_exists?).with(gif_path).and_return gif_status
    end

    subject { described_class.new(gif_path).create_link }

    context 'when the gif link does not exist' do
      it { is_expected.to be_nil }

      xit 'it does not load the record'

      let(:gif_status) { false }
    end

    context 'when the gif link does exist' do
      xit 'loads the record'
      xit 'returns true'

      let(:gif_status) { true }
    end
  end

  describe '#to_s' do
    subject { described_class.new(gif_path).to_s }

    context 'when a link is created' do
      before do


      end
    end

    context 'when a link is not created' do
      it { is_expected.to be_nil }
    end
  end

  let(:gif_path) { existing_gif }
end

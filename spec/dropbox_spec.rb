require 'spec_helper'

RSpec.describe Gifs::Dropbox do
  include_context 'dropbox api'

  describe '#public_link' do
    subject { described_class.new.public_link file_path: default_gif_path }

    context 'when a link already exists' do
      before { stub_link_exists default_gif_path }

      it 'returns a valid Link' do
        expect(subject).to be_a Gifs::Link
      end
    end

    context 'when a link does not exist' do
      before do
        stub_link_non_existent default_gif_path
        stub_create_success default_gif_path
      end

      it 'creates a link and returns a public dropbox url' do
        expect(subject).to be_a Gifs::Link
      end
    end

    context 'when the api returns an error' do
      before { stub_file_not_found default_gif_path }

      it 'raises an error' do
        expect { subject }.to raise_error Gifs::Dropbox::Error
      end
    end
  end
end

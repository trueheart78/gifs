require 'spec_helper'

RSpec.describe Gifs::Entry do
  include_context 'database'

  before do
    allow(Gifs::Dropbox).to receive(:new).and_return(fake_dropbox)
    allow(fake_dropbox).to receive(:public_link).with(link_params).and_return(fake_link)
  end

  describe '#create_link' do
    before do
      allow(Gifs).to receive(:gif_exists?).with(gif_path).and_return gif_status
    end

    subject { described_class.new(gif_path).create_link }

    context 'when the gif does not exist' do
      it { is_expected.to be_nil }

      it 'it does not load the record' do
        subject
        expect(fake_dropbox).not_to have_received(:public_link)
      end

      let(:gif_status) { false }
    end

    context 'when the gif does exist' do
      context 'when it has never been created' do
        it 'it calls dropbox to create the link' do
          subject
          expect(fake_dropbox).to have_received(:public_link)
        end

        it 'returns true' do
          expect(subject).to eq true
        end
      end

      context 'when it has been created and is cached' do
        it 'it does not call dropbox to create the link' do
          subject
          expect(fake_dropbox).not_to have_received(:public_link)
        end

        let!(:gif) do
          FactoryBot.create :existing_gif, basename: basename, directory: directory, size: size
        end
        let!(:shared_link) { FactoryBot.create :shared_link, gif: gif }
      end

      context 'when it has been created but not cached in the database' do
        it 'it calls dropbox to create the link' do
          subject
          expect(fake_dropbox).to have_received(:public_link)
        end

        it 'creates the expected database entries' do
          subject
          expect(new_record).not_to be_nil
          expect(new_record.shared_link).not_to be_nil
        end

        it 'should have a count of 1' do
          subject
          expect(new_record.count).to eq 1
        end

        let(:new_record) { Gifs::Models::Gif.first }
      end

      let(:gif_status) { true }
      let(:gif_path)   { existing_gif }
      let(:basename)   { File.basename gif_path }
      let(:directory)  { File.dirname gif_path }
      let(:size)       { File.size Gifs.gif_path(gif_path) }
    end
  end

  describe '#to_s' do
    subject { described_class.new(gif_path).to_s }

    context 'when a link is created' do
      it 'returns the expected string' do
        expect(subject).to eq expected_output
      end

      let(:expected_output) do
        "[1] [#{File.dirname(gif_path)}] #{fake_link.basename} " \
        "(#{fake_link.size} B) [used: #{fake_link.count}]".colorize(Gifs::Theme.new_entry)
      end
    end

    xcontext 'when a link is not created' do
      it { is_expected.to be_nil }
    end
  end

  let(:gif_path)     { existing_gif }
  let(:fake_dropbox) { instance_double "Gifs::Dropbox" }
  let(:link_params) do
    {
      file_path: gif_path
    }
  end
end

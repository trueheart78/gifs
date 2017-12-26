require 'spec_helper'

RSpec.describe Gifs do
  include_context 'database'

  it 'has a version number' do
    expect(Gifs::VERSION).not_to be nil
  end

  describe '.dropbox_path' do
    subject { described_class.dropbox_path }

    context 'and the directory exists' do
      it 'returns the directory' do
        expect(subject).to eq dropbox_path
      end

      let(:dropbox_path) { fixture_dir }
    end

    context 'and the directory does not exist' do
      it 'falls back to checking for the default directory' do
        expect(subject).to eq fixture_dir
      end

      let(:dropbox_path) { File.join(fixture_dir, '_i_dont_exist_') }
    end
  end

  describe '.gifs_path' do
    subject { described_class.gifs_path }

    before do
      allow(described_class).to receive(:dropbox_path).and_return fixture_dir
    end

    context 'with default parameters' do
      it 'append /gifs onto the dropbox_path' do
        expect(subject).to eq gifs_path
      end

      let(:gifs_path) { File.join [fixture_dir, 'gifs', nil].compact }
    end

    context 'with a passed parameter' do
      subject { described_class.gifs_path file_name }

      it 'append /gifs onto the dropbox_path' do
        expect(subject).to eq gifs_path
      end

      let(:file_name) { "#{junk}.gif" }
      let(:gifs_path) { File.join fixture_dir, 'gifs', file_name }
    end
  end

  describe '.gif_exists?' do
    subject { described_class.gif_exists? file_name }

    before do
      allow(described_class).to receive(:dropbox_path).and_return fixture_dir
    end

    context 'when passed an existing gif' do
      it { is_expected.to eq true }

      let(:file_name) { existing_gif }
    end

    context 'when passed a non existing gif' do
      it { is_expected.to eq false }

      let(:file_name) { non_existent_gif }
    end
  end

  describe '.db_connect' do
    subject { described_class.db_connect }

    context 'when the database exists' do
      before { subject }

      it { is_expected.to eq true }
    end

    context 'when the database does not exist' do
      before { remove_database_file }

      it 'creates the database' do
        subject
        expect(database_file?).to eq true
      end

      it { is_expected.to eq true }
    end
  end

  describe '.db_path' do
    subject { described_class.db_path }

    before do
      allow(described_class).to receive(:db_path).and_call_original
      allow(described_class).to receive(:gifs_path).and_return temp_database_dir
    end

    it 'appends the database filename onto the gifs_path' do
      expect(subject).to eq database_path
    end

    let(:database_path) { File.join temp_database_dir, 'ruby_gif_manager.db' }
  end
end

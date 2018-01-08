require 'spec_helper'

RSpec.describe Gifs::Models::DropboxLink do
  include_context 'database'

  context 'gif association' do
    subject { described_class.reflect_on_association :gif }

    it { is_expected.not_to be_nil }

    it 'is not dependent' do
      expect(subject.options[:dependent]).to be_nil
    end
  end

  describe '#url' do
    subject { dropbox_link.url }

    it { is_expected.to eq expected_url }

    it 'returns a url' do
      expect(subject).to eq expected_url
    end

    junklet :dropbox_id
    let(:remote_path) { "s/#{junk}/#{junk}.gif" }
    let(:expected_url) do
      URI.join(Gifs::Dropbox::PUBLIC_HOST, remote_path).to_s
    end

    let(:dropbox_link) do
      FactoryBot.create :dropbox_link, dropbox_id: dropbox_id, remote_path: remote_path
    end
  end
end

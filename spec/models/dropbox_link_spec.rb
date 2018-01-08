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

    it 'returns a url' do
      expect(subject).to eq expected_url
    end

    let(:expected_url) do
      URI.join(Gifs::Dropbox::PUBLIC_HOST, remote_path).to_s
    end
  end

  describe '#to_md' do
    subject { dropbox_link.to_md }

    it 'returns markdown for an image' do
      expect(subject).to eq expected_md
    end

    let(:expected_md) do
      "![#{dropbox_link.base_name}](#{dropbox_link.url})"
    end
  end

  junklet :dropbox_id
  let(:remote_path) { "s/#{junk}/#{junk}.gif" }

  let(:dropbox_link) do
    FactoryBot.create :dropbox_link,
                      dropbox_id: dropbox_id,
                      remote_path: remote_path
  end
end

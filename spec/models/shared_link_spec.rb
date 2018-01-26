require 'spec_helper'

RSpec.describe Gifs::Models::SharedLink do
  include_context 'database'

  context 'gif association' do
    subject { described_class.reflect_on_association :gif }

    it { is_expected.not_to be_nil }

    it 'is not dependent' do
      expect(subject.options[:dependent]).to be_nil
    end
  end

  context 'public api' do
    subject { described_class.new }

    it { is_expected.to respond_to :dropbox_id }
    it { is_expected.to respond_to :remote_path }
    it { is_expected.to respond_to :count }
  end

  describe '#count' do
    subject { described_class.new.count }

    it 'defaults to 0' do
      is_expected.to eq 0
    end
  end

  describe '#url' do
    subject { shared_link.url }

    it 'returns a url' do
      expect(subject).to eq expected_url
    end

    let(:expected_url) do
      URI.join(Gifs::Dropbox::PUBLIC_HOST, File.join(remote_path, basename)).to_s
    end
  end

  describe '#md' do
    subject { shared_link.md }

    it 'returns markdown for an image' do
      expect(subject).to eq expected_md
    end

    let(:expected_md) do
      "![#{shared_link.basename}](#{shared_link.url})"
    end
  end

  junklet :dropbox_id
  let(:remote_path) { "/s/#{junk}" }
  let(:basename)    { 'sample.gif' }

  let(:shared_link) do
    FactoryBot.create :shared_link,
                      dropbox_id: dropbox_id,
                      remote_path: remote_path
  end
end

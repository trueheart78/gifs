# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gifs::Link do
  it_behaves_like 'it has public link methods', object: described_class.new(hash)

  describe '#id' do
    subject { described_class.new(hash).id }

    it 'should equal the corresponding dropbox id string' do
      expect(subject).to eq fake_id
    end
  end

  describe '#basename' do
    subject { described_class.new(hash).basename }

    it 'should equal the expected basename' do
      expect(subject).to eq 'sample.gif'
    end
  end

  describe '#directory' do
    subject { described_class.new(hash).directory }

    it 'should equal the expected directory' do
      expect(subject).to eq File.dirname(hash[:path_lower])
    end
  end

  describe '#url' do
    subject { described_class.new(hash).url }

    it 'should equal the expected url' do
      expect(subject).to eq fake_url
    end
  end

  describe '#remote_path' do
    subject { described_class.new(hash).remote_path }

    it 'should equal the expected remote_path' do
      expect(subject).to eq expected_string
    end

    let(:expected_string) { '/s/fakeDropboxString' }
  end

  describe '#md' do
    subject { described_class.new(hash).md }

    it 'should equal the expected markdown' do
      expect(subject).to eq expected_string
    end

    let(:expected_string) { "![sample.gif](#{fake_url})" }
  end

  describe '#to_s' do
    subject { described_class.new(hash).to_s }

    it 'should equal the expected string' do
      expect(subject).to eq expected_string
    end

    let(:expected_string) { "#{fake_id}: #{fake_url}" }
  end

  let(:hash) do
    {
      id: "id:#{fake_id}",
      path_lower: existing_gif,
      url: fake_dropbox_url
    }
  end
end

# frozen_string_literal: true

require 'spec_helper'
require 'gifs/config'

RSpec.describe Gifs::Config do
  include_context 'clean environment'

  describe 'constants' do
    it 'has a dropbox path' do
      expect(described_class::DROPBOX_PATH).not_to be nil
    end

    it 'has a dropbox token' do
      expect(described_class::DROPBOX_TOKEN).not_to be nil
    end
  end

  describe '.dropbox_path' do
    before do
      stub_const("#{described_class}::CONFIG_FILE", config_file)
      allow(File).to receive(:expand_path).with('~/Dropbox').and_return dropbox_path
    end

    context 'when the config file exists' do
      subject { instance.dropbox_path }

      it 'returns the expected value' do
        expect(subject).to eq dropbox_path
      end

      let(:config_file) { fixture_path 'config/valid.yaml' }
    end

    context 'when the config files does not exist' do
      subject { instance.dropbox_path }

      it 'raises a ConfigNotFound error' do
        expect { subject }.to raise_error described_class::ConfigNotFound
      end

      let(:config_file) { fixture_path 'config/missing.yaml' }
    end

    context 'when the config file does not include all requirements' do
      subject { instance.dropbox_path }

      it 'raises a MissingConfigValues error' do
        expect { subject }.to raise_error described_class::MissingConfigValues
      end

      let(:config_file) { fixture_path 'config/invalid.yaml' }
    end

    let(:instance)     { Class.new(described_class).instance }
    let(:dropbox_path) { fixture_dir }
  end
end

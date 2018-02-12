# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gifs::InputHandler do
  subject { new_handler }

  before do
    allow_any_instance_of(described_class).to receive(:create_entry).and_return nil
  end

  describe '#mode' do
    context 'when called before #process' do
      it 'calls #process' do
        expect(subject).to receive(:process)
        subject.mode
      end
    end

    context 'when called after #process' do
      before { subject.process }

      it 'does not call #process' do
        expect(subject).not_to receive(:process)
        subject.mode
      end
    end

    context 'when passed a markdown mode change string' do
      subject { new_handler.mode }

      it { is_expected.to eq :md }

      let(:input) { 'md' }
    end

    context 'when passed a url mode change string' do
      subject { new_handler.mode }

      it { is_expected.to eq :url }

      let(:input) { 'url' }
    end

    context 'when not passed a mode change string' do
      subject { new_handler.mode }

      it 'should remain the same as the passed in mode' do
        expect(subject).to eq default_mode
      end

      let(:input) { 'exit' }
    end
  end

  describe '#continue?' do
    context 'when called before #process' do
      it 'calls #process' do
        expect(subject).to receive(:process)
        subject.continue?
      end
    end

    context 'when called after #process' do
      before { subject.process }

      it 'does not call #process' do
        expect(subject).not_to receive(:process)
        subject.continue?
      end
    end

    context 'when passed an exit string' do
      subject { new_handler.continue? }

      it { is_expected.to eq false }

      let(:input) { 'exit' }
    end

    context 'when not passed an exit string' do
      subject { new_handler.continue? }

      it { is_expected.to eq true }

      let(:input) { 'md' }
    end
  end

  describe '#mode_change?' do
    context 'when called before #process' do
      it 'calls #process' do
        expect(subject).to receive(:process)
        subject.mode_change?
      end
    end

    context 'when called after #process' do
      before { subject.process }

      it 'does not call #process' do
        expect(subject).not_to receive(:process)
        subject.mode_change?
      end
    end

    context 'when passed a mode change string' do
      subject { new_handler.mode_change? }

      it { is_expected.to eq true }

      let(:input) { 'md' }
    end

    context 'when not passed a mode change string' do
      subject { new_handler.mode_change? }

      it { is_expected.to eq false }

      let(:input) { 'exit' }
    end
  end

  describe '#process' do
    before do
      [existing_gifs, non_existent_gif].flatten.each do |gif|
        allow(subject).to receive(:create_entry).with(gif).and_call_original
        allow(Gifs::Entry).to receive(:new).with(gif).and_return fake_entry
      end
      allow(fake_entry).to receive(:create_link)
      subject.process
    end

    context 'when passed a single gif' do
      it 'makes the expected call to #create_entry' do
        expect(subject).to have_received(:create_entry).with input
      end

      it 'instantiates an Entry' do
        expect(Gifs::Entry).to have_received(:new).with input
      end

      it 'calls Entry#create_link' do
        expect(fake_entry).to have_received(:create_link)
      end

      let(:input) { existing_gif }
    end

    context 'when passed multiple gifs' do
      it 'makes the expected calls to #create_entry' do
        existing_gifs.each do |gif|
          expect(subject).to have_received(:create_entry).with gif
        end
      end

      it 'instantiates an Entry' do
        existing_gifs.each do |gif|
          expect(Gifs::Entry).to have_received(:new).with gif
        end
      end

      it 'calls Entry#create_link' do
        expect(fake_entry).to have_received(:create_link).twice
      end

      let(:input) { existing_gifs.join(' ') }
    end

    context 'when apostrophes are detected' do
      it 'makes the expected calls to #create_entry' do
        existing_gifs.each do |gif|
          expect(subject).to have_received(:create_entry).with gif
        end
      end

      it 'instantiates an Entry' do
        existing_gifs.each do |gif|
          expect(Gifs::Entry).to have_received(:new).with gif
        end
      end

      it 'calls Entry#create_link' do
        expect(fake_entry).to have_received(:create_link).twice
      end

      let(:input) { "'#{existing_gifs.join("' '")}'" }
    end

    context 'when double quotes are detected' do
      it 'makes the expected calls to #create_entry' do
        existing_gifs.each do |gif|
          expect(subject).to have_received(:create_entry).with gif
        end
      end

      it 'instantiates an Entry' do
        existing_gifs.each do |gif|
          expect(Gifs::Entry).to have_received(:new).with gif
        end
      end

      it 'calls Entry#create_link' do
        expect(fake_entry).to have_received(:create_link).twice
      end

      let(:input) { "\"#{existing_gifs.join('" "')}\"" }
    end

    context 'when escaped strings are detected' do
      it 'makes the expected calls to #create_entry' do
        existing_gifs.each do |gif|
          expect(subject).to have_received(:create_entry).with gif
        end
      end

      it 'instantiates an Entry' do
        existing_gifs.each do |gif|
          expect(Gifs::Entry).to have_received(:new).with gif
        end
      end

      it 'calls Entry#create_link' do
        expect(fake_entry).to have_received(:create_link).twice
      end

      let(:input) { existing_gifs.join(' ').gsub(' ', '\ ') }
    end

    context 'when a non-existent gif is passed in' do
      it 'makes the expected calls to #create_entry' do
        expect(subject).to have_received(:create_entry).with input
      end

      it 'does not instantiate an Entry' do
        expect(Gifs::Entry).not_to have_received(:new).with input
      end

      let(:input) { non_existent_gif }
    end

    context 'when a non-existent and existent gif are passed in' do
      it 'makes the expected calls to #create_entry' do
        mixed_existence_gifs.each do |gif|
          expect(subject).to have_received(:create_entry).with gif
        end
      end

      it 'instantiates an Entry for the existing gif' do
        expect(Gifs::Entry).to have_received(:new).with existing_gif
      end

      it 'does not instantiate an Entry for the non-existent gif' do
        expect(Gifs::Entry).not_to have_received(:new).with non_existent_gif
      end

      it 'calls Entry#create_link once for the existing gif' do
        expect(fake_entry).to have_received(:create_link).once
      end

      let(:input) { mixed_existence_gifs.join ' ' }
    end

    let(:fake_entry) { instance_double 'Entry' }
  end

  let(:input)        { existing_gif }
  let(:default_mode) { :url }
  let(:new_handler) do
    described_class.new input: input, mode: default_mode
  end
end

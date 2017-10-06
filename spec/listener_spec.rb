require 'spec_helper'

RSpec.describe Gifs::Listener do
  describe '.start' do
    before do
      allow(Gifs).to receive(:exist?).and_return false
      allow(described_class).to receive(:prompt_input).and_return complete_input
    end

    subject do
      capture_output { described_class.start }
    end

    context 'when a files does not exist' do
      it 'outputs an error' do
        expect(subject).to include error_message
      end

      let(:sample_gifs)   { %w[aaaa.gif] }
      let(:error_message) { compose_error(sample_gifs.first) }
    end

    context 'when multiple files do not exist' do
      it 'outputs multiple errors' do
        expect(subject).to include error_message
      end

      let(:sample_gifs) { %w[aaaa.gif bbbb.gif] }
      let(:error_message) do
        sample_gifs.map { |gif| compose_error gif }.join
      end
    end

    context 'when a file exists' do
      before do
        allow(Gifs).to receive(:gif_exists?).and_return true
        allow(Clipboard).to receive(:copy)
        allow(Gifs::Dropbox).to receive(:new).and_return dropbox_double
        allow(link_double).to receive(:url).and_return url
        allow(link_double).to receive(:to_md).and_return markdown
      end

      it 'outputs success' do
        expect(subject).to include sample_gifs.first
        expect(subject).to include url
        expect(subject).to include markdown
      end

      junklet :url, :markdown
      let(:sample_gifs)    { %w[thumbs\ up/sample.gif] }
      let(:error_message)  { compose_success(sample_gifs.first) }
      let(:dropbox_double) { instance_double 'Gifs::Dropbox', public_link: link_double }
      let(:link_double)    { instance_double 'Gifs::Link' }
    end

    let(:complete_input) { "#{sample_gifs.join(' ')} #{exit_command}" }
    let(:exit_command)   { 'exit' }
  end

  def compose_success(file)
    ">> existing dropbox path << [#{file}]\n"
  end

  def compose_error(file)
    "error: file does not exist [#{file}]\n"
  end
end

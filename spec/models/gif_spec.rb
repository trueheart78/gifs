require 'spec_helper'

RSpec.describe Gifs::Models::Gif do
  include_context 'database'

  context 'dropbox link association' do
    subject { described_class.reflect_on_association :dropbox_link }

    it { is_expected.not_to be_nil }

    it 'is not dependent' do
      expect(subject.options[:dependent]).to be_nil
    end
  end

  context 'public api' do
    subject { described_class.new }

    it { is_expected.to respond_to :base_name }
    it { is_expected.to respond_to :directory }
    it { is_expected.to respond_to :size }
  end
end

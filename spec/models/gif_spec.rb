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

  subject {}
end

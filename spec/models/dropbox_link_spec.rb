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
end

require 'spec_helper'

RSpec.describe Gifs do
  it 'has a version number' do
    expect(Gifs::VERSION).not_to be nil
  end

  it 'has an environment dir key' do
    expect(Gifs::ENV_DIR_KEY).not_to be nil
  end
end

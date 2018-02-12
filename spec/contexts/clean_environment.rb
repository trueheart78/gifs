# frozen_string_literal: true

RSpec.shared_context 'clean environment' do
  after(:each) do
    ENV[Gifs::Config::DROPBOX_PATH] = env_bak[:path]
    ENV[Gifs::Config::DROPBOX_TOKEN] = env_bak[:token]
  end

  let!(:env_bak) do
    {
      path: ENV.delete(Gifs::Config::DROPBOX_PATH),
      token: ENV.delete(Gifs::Config::DROPBOX_TOKEN)
    }
  end
end

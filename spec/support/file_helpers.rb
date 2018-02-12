# frozen_string_literal: true

def fixture_dir
  File.join Dir.getwd, 'spec', 'fixtures'
end

def fixture_path(file)
  File.join fixture_dir, file
end

def gif_dir
  File.join fixture_dir, 'gifs'
end

def gif_path(file)
  File.join gif_dir, file
end

def fake_dropbox_url
  'https://www.dropbox.com/s/fakeDropboxString/sample.gif?dl=0'
end

def fake_link
  @fake_link ||= FakeLink.new fake_id,
                              existing_gif,
                              0,
                              1,
                              fake_url
end

# rubocop:disable LineLength
def fake_url
  @fake_url ||= URI.join(Gifs::Dropbox::PUBLIC_HOST, '/s/fakeDropboxString/', File.basename(existing_gif)).to_s
end
# rubocop:enable LineLength

def fake_id
  @fake_id ||= 'fakeDropboxId'
end

def existing_gifs
  ['thumbs up/sample.gif', 'thumbs down/sample.gif']
end

def existing_gif
  @existing_gif ||= existing_gifs.sample
end

def non_existent_gif
  @non_existent_gif ||= 'missing/missing.gif'
end

def mixed_existence_gifs
  @mixed_existence_gifs ||= [existing_gif, non_existent_gif].shuffle
end

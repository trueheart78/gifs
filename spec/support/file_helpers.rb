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

def existing_gifs
  ['thumbs up/sample.gif', 'thumbs down/sample.gif']
end

def existing_gif
  existing_gifs.sample
end

def non_existent_gif
  "#{junk}.gif"
end

FactoryBot.define do
  factory :gif, aliases: [:existing_gif], class: Gifs::Models::Gif do
    base_name 'sample.gif'
    directory 'thumbs up'
    size 4000

    factory :missing_gif do
      directory 'empty'
    end

    factory :thumbs_up_gif do
      directory 'thumbs up'
    end

    factory :thumbs_down_gif do
      directory 'thumbs down'
    end
  end
end

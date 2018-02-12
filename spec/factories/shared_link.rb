FactoryBot.define do
  factory :shared_link, aliases: [:link], class: Gifs::Models::SharedLink do
    association :gif, factory: :existing_gif
    id { SecureRandom.uuid }
    remote_path 's/1234567890abc/'
  end
end
